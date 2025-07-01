//
//  AblyFetcher.swift
//  BestWish
//
//  Created by 백래훈 on 6/9/25.
//

import Foundation

import SwiftSoup

/// 에이블리 Fetcher
final class AblyFetcher: ProductDTORepository {
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
            
            // JsonData 혹은 Body에 필요한 데이터가 있는 경우 추추출
            let price = html.htmlExtractValue(pattern: #""thumbnail_price"\s*:\s*(\d+)"#) { Int($0) }
            let discountRate = html.htmlExtractValue(pattern: #""discount_rate"\s*:\s*(\d+)"#) { $0 }
            let brand = try doc.select("p.typography.typography__subtitle2.color__gray70").first()?.text()
            
            return ProductDTO(
                id: nil,
                userID: nil,
                platform: 3,
                title: title,
                price: price,
                discountRate: discountRate ?? "0",
                brand: brand,
                imagePathURL: imageURL,
                productURL: deepLink?.absoluteString,
                createdAt: nil
            )
        } catch {
            throw ProductSyncError.jsonDecodingFailed
        }
    }
}
