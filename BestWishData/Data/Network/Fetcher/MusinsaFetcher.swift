//
//  MusinsaFetcher.swift
//  BestWish
//
//  Created by 백래훈 on 6/9/25.
//

import Foundation

internal import SwiftSoup

/// 무신사 Fetcher
final class MusinsaFetcher: ProductDTOFetcher {
    /// 상품 데이터 fetch
    func fetchProductDTO(deepLink: URL?, productURL: URL?, html: String?) async throws -> ProductDTO {
        guard let html else {
            throw ProductSyncError.htmlParsingFailed
        }
        do {
            let doc = try SwiftSoup.parse(html)
            
            // SwiftSoup으로 파싱 헤더에 데이터가 있을 때만 가능
            let title = try doc.title()
            let imageURL = try doc.select("meta[property=og:image]").attr("content")
            let price = Int(try doc.select("meta[property=product:price:amount]").first()?.attr("content") ?? "")
            let discountRate = try doc.select("meta[property=product:price:sale_rate]").first()?.attr("content")
            let brand = try doc.select("meta[property=product:brand]").first()?.attr("content")
            
            return ProductDTO(
                id: nil,
                userID: nil,
                platform: 1,
                title: title,
                price: price,
                discountRate: discountRate ?? "0",
                brand: brand,
                imagePathURL: imageURL,
                productURL: deepLink?.absoluteString,
                createdAt: nil
            )
        } catch {
            throw ProductSyncError.dataLoadingFailed
        }
    }
}
