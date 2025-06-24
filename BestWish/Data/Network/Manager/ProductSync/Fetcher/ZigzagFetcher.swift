//
//  ZigzagFetcher.swift
//  BestWish
//
//  Created by 백래훈 on 6/9/25.
//

import Foundation

import RxSwift

/// 지그재그 fetcher
final class ZigzagFetcher: HTMLProductDTOFetcher {
    /// 상품 데이터 fetch
    func fetchProductDTO(ogUrl: URL, extraUrl: URL, html: String) async throws -> ProductDTO {
        let brand = html.slice(from: "property=\"product:brand\" content=\"", to: "\"")
        let title = html.slice(from: "property=\"og:title\" content=\"", to: "\"")
        let image = html.slice(from: "property=\"og:image\" content=\"", to: "\"")

        guard let json = html.extractNEXTDataJSON() else {
            throw ShareExtensionError.jsonScriptParsingFailed
        }

        let deeplinkUrlPattern = #""deeplink_url"\s*:\s*"([^"]+)""#
        let discountRatePattern = #""discount_rate"\s*:\s*"?([0-9]+)"?"#
        let discountPricePattern = #""discount_price"\s*:\s*"?([0-9]+)"?"#

        guard let deeplinkUrl = json.firstMatch(for: deeplinkUrlPattern),
              let discountRate = json.firstMatch(for: discountRatePattern),
              let discountPrice = json.firstMatch(for: discountPricePattern) else {
            throw ShareExtensionError.invalidProductData
        }

        let segments = deeplinkUrl.components(separatedBy: #"\u0026"#)
        let filtered = [0, 2, 3].compactMap { $0 < segments.count ? segments[$0] : nil }
        let finalDeeplink = filtered.joined(separator: "&")

        return ProductDTO(
            id: nil,
            userID: nil,
            platform: 2,
            title: title,
            price: Int(discountPrice),
            discountRate: discountRate,
            brand: brand,
            imagePathURL: image,
            productURL: finalDeeplink,
            createdAt: nil
        )
    }
}
