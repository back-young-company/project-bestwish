//
//  MusinsaFetcher.swift
//  BestWish
//
//  Created by 백래훈 on 6/9/25.
//

import Foundation

import RxSwift

/// 무신사 Fetcher
final class MusinsaFetcher: ShareMetadataFetcher {
    func fetchMetadata(ogUrl: URL, extraUrl: URL) async throws -> ProductMetadataDTO {
        let (data, _) = try await URLSession.shared.data(from: extraUrl)
        guard let html = String(data: data, encoding: .utf8) else {
            throw ShareExtensionError.dataLoadingFailed
        }

        if let productURLString = html.firstMatch(for: #"link=(https:\/\/www\.musinsa\.com\/products\/\d+)"#),
           let redirectedURL = URL(string: productURLString),
           redirectedURL != extraUrl {
            return try await fetchMetadata(ogUrl: ogUrl, extraUrl: redirectedURL)
        }

        guard let json = html.extractNEXTDataJSON() else {
            throw ShareExtensionError.jsonScriptParsingFailed
        }

        let goodsNmPattern = #""goodsNm"\s*:\s*"([^"]+)""#
        let thumbnailImageUrlPattern = #""thumbnailImageUrl"\s*:\s*"([^"]+)""#
        let brandNamePattern = #""brandName"\s*:\s*"([^"]+)""#
        let salePricePattern = #""salePrice"\s*:\s*"?([0-9]+)"?"#
        let discountRatePattern = #""discountRate"\s*:\s*"?([0-9]+)"?"#

        guard let goodsNm = json.firstMatch(for: goodsNmPattern),
              let thumbnailImageUrl = json.firstMatch(for: thumbnailImageUrlPattern),
              let brandName = json.firstMatch(for: brandNamePattern),
              let salePrice = json.firstMatch(for: salePricePattern),
              let discountRate = json.firstMatch(for: discountRatePattern) else {
            throw ShareExtensionError.invalidProductData
        }

        return ProductMetadataDTO(
            platform: 1,
            productName: goodsNm,
            brandName: brandName,
            discountRate: discountRate,
            price: salePrice,
            imageURL: "https://image.msscdn.net" + thumbnailImageUrl,
            productURL: ogUrl,
            extra: nil
        )
    }

    private static func parseTitle(_ title: String) -> (brand: String?, product: String?, extra: String?) {
        guard let firstSpaceRange = title.range(of: " ") else {
            return (nil, nil, nil)
        }
        let brand = String(title[..<firstSpaceRange.lowerBound])
        let remainder = String(title[firstSpaceRange.upperBound...])
        let productAndExtra = remainder.components(separatedBy: " - ")
        let product = productAndExtra.first
        let extra = productAndExtra.count > 1 ? productAndExtra[1] : nil
        return (brand, product, extra)
    }
}
