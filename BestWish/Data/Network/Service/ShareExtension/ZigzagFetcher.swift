//
//  ZigzagFetcher.swift
//  BestWish
//
//  Created by 백래훈 on 6/9/25.
//

import Foundation

import RxSwift

// MARK: - Zigzag Fetcher
class ZigzagFetcher: HTMLBasedMetadataFetcher {
    func fetchMetadata(ogUrl: URL, extraUrl: URL, html: String) -> Single<ProductMetadataDTO> {
        return Single<ProductMetadataDTO>.create { single in
            let brand = html.slice(from: "property=\"product:brand\" content=\"", to: "\"")
            let title = html.slice(from: "property=\"og:title\" content=\"", to: "\"")
            let image = html.slice(from: "property=\"og:image\" content=\"", to: "\"")
            let amountPrice = html.slice(from: "property=\"product:price:amount\" content=\"", to: "\"")
            
            if let json = html.extractapplicationLdJson() {
                let pattern = #""deeplink_url"\s*:\s*"([^"]+)""#
                if let match = json.firstMatch(for: pattern) {
                    print("정규식으로 추출된 deeplink_url: \(match)")
                    
                    // 수동으로 \\u0026로 분할하여 중복 파라미터 제거
                    let segments = match.components(separatedBy: #"\u0026"#)
                    print("정제된 딥링크: \(segments)")
                    
                    // 필요한 인덱스만 선택 (0, 2, 3번째 항목)
                    let filtered = [0, 2, 3].compactMap { $0 < segments.count ? segments[$0] : nil }
                    let finalDeeplink = filtered.joined(separator: "&")
                    print("최종 딥링크: \(finalDeeplink)")
                    
                    let metadata = ProductMetadataDTO(
                        productName: title,
                        brandName: brand,
                        discountRate: "0",
                        price: amountPrice,
                        imageURL: image,
                        productURL: URL(string: finalDeeplink),
                        extra: nil
                    )
                    single(.success(metadata))
                }
            }
            return Disposables.create()
        }
    }
    
    func extractZigzagDeeplinkFromScript(in html: String) -> URL? {
        let pattern = #"<script[^>]*id="__NEXT_DATA__"[^>]*>(.*?)</script>"#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators]),
              let match = regex.firstMatch(in: html, range: NSRange(html.startIndex..., in: html)),
              let range = Range(match.range(at: 1), in: html)
        else {
            return nil
        }

        let jsonString = String(html[range])

        guard let data = jsonString.data(using: .utf8),
              let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let props = jsonObject["props"] as? [String: Any],
              let pageProps = props["pageProps"] as? [String: Any],
              let deeplink = pageProps["deeplink_url"] as? String
        else {
            return nil
        }

        return URL(string: deeplink.removingPercentEncoding ?? deeplink)
    }
    
    func extractDeeplinkURL(from html: String) -> URL? {
        let pattern = #""deeplink_url"\s*:\s*"([^"]+)""#
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: html, range: NSRange(html.startIndex..., in: html)),
              let range = Range(match.range(at: 1), in: html)
        else {
            return nil
        }

        let raw = String(html[range])
        let decoded = raw.removingPercentEncoding ?? raw
        return URL(string: decoded)
    }
    
    func extractEncodedDeeplinkURL(from html: String) -> URL? {
        let pattern = #"deeplink_url=([^&\\"]+)"#
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: html, range: NSRange(html.startIndex..., in: html)),
              let range = Range(match.range(at: 1), in: html)
        else {
            return nil
        }

        let encoded = String(html[range])
        let decoded = encoded.removingPercentEncoding ?? encoded
        return URL(string: decoded)
    }
    
    func extractZigzagDeeplink(from html: String) -> URL? {
        return extractZigzagDeeplinkFromScript(in: html) ??
               extractDeeplinkURL(from: html) ??
               extractEncodedDeeplinkURL(from: html)
    }
    
    func extractScriptContent(withId id: String, from html: String) -> String? {
        let pattern = #"<script[^>]*id="\#(id)"[^>]*>(.*?)</script>"#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators]),
              let match = regex.firstMatch(in: html, range: NSRange(html.startIndex..., in: html)),
              let range = Range(match.range(at: 1), in: html)
        else {
            return nil
        }

        return String(html[range])
    }
    
    func extractScriptContents(ofType type: String, from html: String) -> [String] {
        let pattern = #"<script[^>]*type="\#(type)"[^>]*>(.*?)</script>"#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators]) else {
            return []
        }

        let results = regex.matches(in: html, range: NSRange(html.startIndex..., in: html))
        return results.compactMap { match in
            guard let range = Range(match.range(at: 1), in: html) else { return nil }
            return String(html[range])
        }
    }
    
    
}
