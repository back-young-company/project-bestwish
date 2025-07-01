//
//  HiverFetcher.swift
//  BestWish
//
//  Created by Quarang on 6/29/25.
//

import Foundation

import SwiftSoup

/// Hiver 페쳐
final class HiverFetcher: ProductDTOFetcher {
    /// 하이버 제품 상세 HTML → ProductDTO 파싱
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
            let price = html.htmlExtractValue(pattern: #""sale_price"\s*:\s*(\d+)"#, transform: { Int($0) })
            let discountRate = html.htmlExtractValue(pattern: #""original_sale_percent"\s*:\s*(\d+)"#, transform: { $0 })
            let sellerName = html.htmlExtractValue(pattern: #""seller"\s*:\s*\{[^}]*?"name"\s*:\s*"([^"]+)""#, transform: { $0 })
            
            return ProductDTO(
                id: nil,
                userID: nil,
                platform: 8,
                title: title,
                price: price,
                discountRate: discountRate ?? "0",
                brand: sellerName,
                imagePathURL: imageURL,
                productURL: deepLink?.absoluteString,
                createdAt: nil
            )
        } catch {
            throw ProductSyncError.dataLoadingFailed
        }
    }
}
