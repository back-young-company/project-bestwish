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
            
            if let json = html.extractNEXTDataJSON() {
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
                } else {
                    single(.failure(ShareExtensionError.invalidProductData))
                }
            } else {
                single(.failure(ShareExtensionError.jsonScriptParsingFailed))
            }
            return Disposables.create()
        }
    }
}
