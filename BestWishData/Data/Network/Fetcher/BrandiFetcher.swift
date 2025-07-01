//
//  BrandiFetcher.swift
//  BestWish
//
//  Created by Quarang on 6/27/25.
//

import Foundation

internal import SwiftSoup

/// 브랜디 Fetcher
final class BrandiFetcher: ProductDTOFetcher {
    /// 브랜디 제품 상세 HTML → ProductDTO 파싱
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
            let brand = html.htmlExtractValue(pattern: #""seller"\s*:\s*\{[^}]*?"name"\s*:\s*"([^"]+)""#) { $0 }
            let discountRate = html.htmlExtractValue(pattern: #""sale_percent"\s*:\s*(\d+)"#) { $0 }
            let price = try doc.select("meta[property=og:title]").attr("content").htmlExtractValue(pattern: #"(\d{1,3}(?:,\d{3})*)원"#) { Int($0.replacingOccurrences(of: ",", with: "")) }
            
            return ProductDTO(
                id: nil,
                userID: nil,
                platform: 5,
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

// https://www.brandi.co.kr/products/174895988
