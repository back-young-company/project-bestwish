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
            
            if let json = html.extractNEXTDataJSON() {
                let deeplinkUrl = #""deeplink_url"\s*:\s*"([^"]+)""#
                let discountRate = #""discount_rate"\s*:\s*"?([0-9]+)"?"#
                let discountPrice = #""discount_price"\s*:\s*"?([0-9]+)"?"#
                
                if let deeplinkUrl = json.firstMatch(for: deeplinkUrl),
                   let discountRate = json.firstMatch(for: discountRate),
                    let discountPrice = json.firstMatch(for: discountPrice) {
                    
                    // 수동으로 \\u0026로 분할하여 중복 파라미터 제거
                    let segments = deeplinkUrl.components(separatedBy: #"\u0026"#)
                    print("정제된 딥링크: \(segments)")
                    
                    // 필요한 인덱스만 선택 (0, 2, 3번째 항목)
                    let filtered = [0, 2, 3].compactMap { $0 < segments.count ? segments[$0] : nil }
                    let finalDeeplink = filtered.joined(separator: "&")
                    print("최종 딥링크: \(finalDeeplink)")
                    
                    let metadata = ProductMetadataDTO(
                        platform: 2,
                        productName: title,
                        brandName: brand,
                        discountRate: discountRate,
                        price: discountPrice,
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
