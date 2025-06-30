//
//  ZigzagFetcher.swift
//  BestWish
//
//  Created by 백래훈 on 6/9/25.
//

import Foundation

import SwiftSoup

/// 지그재그 fetcher
final class ZigzagFetcher: ProductDTORepository {
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
            let brand = try doc.select("meta[property=product:brand]").attr("content")
            
            // JsonData 혹은 Body에 필요한 데이터가 있는 경우 추출
            let discountRate = html.htmlExtractValue(pattern: #""discount_rate"\s*:\s*"?([0-9]+)"?"#) { $0 }
            let price = html.htmlExtractValue(pattern: #""discount_price"\s*:\s*"?([0-9]+)"?"#) { Int($0) }
            let deepLinkURL = html.htmlExtractValue(pattern: #""deeplink_url"\s*:\s*"([^"]+)""#) { $0 }

            return ProductDTO(
                id: nil,
                userID: nil,
                platform: 2,
                title: title,
                price: price,
                discountRate: discountRate,
                brand: brand,
                imagePathURL: imageURL,
                productURL: deepLinkURL ?? deepLink?.absoluteString,
                createdAt: nil
            )
        } catch {
            throw ProductSyncError.dataLoadingFailed
        }
    }
}
