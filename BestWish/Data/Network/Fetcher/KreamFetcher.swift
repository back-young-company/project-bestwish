//
//  KreamFetcher.swift
//  BestWish
//
//  Created by Quarang on 6/27/25.
//

import Foundation

import SwiftSoup

/// 크림 페쳐
final class KreamFetcher: ProductDTORepository {
    /// 크림 제품 상세 HTML → ProductDTO 파싱
    func fetchProductDTO(deepLink: URL?, productURL: URL?, html: String?) async throws -> ProductDTO {
        guard let html else {
            throw ProductSyncError.htmlParsingFailed
        }
        do {
            let doc = try SwiftSoup.parse(html)

            // SwiftSoup으로 파싱 헤더에 데이터가 있을 때만 가능
            let title = try doc.select("p.sub-title").first()?.text() ?? ""
            let imageURL = try doc.select("img.full_width.image").first()?.attr("abs:src") ?? ""
            let priceText = try doc.select("p.price").first()?.text() ?? ""
            let price = Int(priceText.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression))
            let brand = try doc.select("p.title-text").first()?.text()
            
            return ProductDTO(
                id: nil,
                userID: nil,
                platform: 4,
                title: title,
                price: price,
                discountRate: nil,
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
