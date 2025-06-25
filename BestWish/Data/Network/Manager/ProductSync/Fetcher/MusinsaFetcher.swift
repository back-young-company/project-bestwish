//
//  MusinsaFetcher.swift
//  BestWish
//
//  Created by 백래훈 on 6/9/25.
//

import Foundation

import RxSwift

/// 무신사 Fetcher
final class MusinsaFetcher: ProductDTORepository {
    /// 상품 데이터 fetch
    func fetchProductDTO(ogUrl: URL?, finalUrl: URL?, html: String?) async throws -> ProductDTO {
        let (data, _) = try await URLSession.shared.data(from: finalUrl!)
        guard let finalHTML = String(data: data, encoding: .utf8) else {
            throw ProductSyncError.dataLoadingFailed
        }

        // 무신사는 최초 공유 링크가 'https://musinsa.onelink.me/PvkC/8o9es6co' 형식
        // 위 형식의 링크로 html 변환 후 JSON 파싱을 시도할 경우 실패
        // firstMatch 메서드를 활용하여 html 내 'https://www.musinsa.com/products/2690691' 형식 링크 탐색
        // 탐색 된 상품 링크로 redirectedURL 생성 및 finalUrl과 비교 진행
        if let productURLString = finalHTML.firstMatch(for: #"link=(https:\/\/www\.musinsa\.com\/products\/\d+)"#),
           let redirectedURL = URL(string: productURLString),
           redirectedURL != finalUrl {
            return try await fetchProductDTO(ogUrl: ogUrl, finalUrl: redirectedURL, html: finalHTML)
        }

        guard let json = finalHTML.extractNEXTDataJSON() else {
            throw ProductSyncError.jsonScriptParsingFailed
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
            throw ProductSyncError.invalidProductData
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
            productURL: ogUrl?.absoluteString,
            createdAt: nil
        )
    }
}
