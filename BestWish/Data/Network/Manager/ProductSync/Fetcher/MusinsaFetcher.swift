//
//  MusinsaFetcher.swift
//  BestWish
//
//  Created by 백래훈 on 6/9/25.
//

import Foundation

import RxSwift

/// 무신사 Fetcher
final class MusinsaFetcher: ProductDTOFetcher {
    /// 상품 데이터 fetch
    func fetchProductDTO(ogUrl: URL, extraUrl: URL) async throws -> ProductDTO {
        let (data, _) = try await URLSession.shared.data(from: extraUrl)
        guard let html = String(data: data, encoding: .utf8) else {
            throw ShareExtensionError.dataLoadingFailed
        }

        if let productURLString = html.firstMatch(for: #"link=(https:\/\/www\.musinsa\.com\/products\/\d+)"#),
           let redirectedURL = URL(string: productURLString),
           redirectedURL != extraUrl {
            return try await fetchProductDTO(ogUrl: ogUrl, extraUrl: redirectedURL)
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

        return ProductDTO(
            id: nil,
            userID: nil,
            platform: 1,
            title: goodsNm,
            price: Int(salePrice),
            discountRate: discountRate,
            brand: brandName,
            imagePathURL: "https://image.msscdn.net" + thumbnailImageUrl,
            productURL: ogUrl.absoluteString,
            createdAt: nil
        )
    }
}
