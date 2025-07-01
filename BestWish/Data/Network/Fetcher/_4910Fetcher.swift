//
//  _4910Fetcher.swift
//  BestWish
//
//  Created by Quarang on 6/28/25.
//

import Foundation

import SwiftSoup

/// 4910 페쳐
final class _4910Fetcher: ProductDTORepository {
    /// 크림 제품 상세 HTML → ProductDTO 파싱
    func fetchProductDTO(deepLink: URL?, productURL: URL?, html: String?) async throws -> ProductDTO {
        guard let html else {
            throw ProductSyncError.htmlParsingFailed
        }
        do {
            let doc = try SwiftSoup.parse(html)

            // SwiftSoup으로 파싱 헤더에 데이터가 있을 때만 가능
            let title = try doc.title()
            let imageURL = try doc.select("img[alt='상품 썸네일'][data-nimg=fill]").first()?.attr("abs:src")
            
            // JsonData 혹은 Body에 필요한 데이터가 있는 경우 추출
            let price = html.htmlExtractValue(pattern: #""discounted_price"\s*:\s*(\d+)"#) { Int($0) }
            let discountRate = html.htmlExtractValue(pattern: #"\"extra_discount\"\s*:\s*\{[^}]*?"discount_rate"\s*:\s*(\d+)"#) { $0 }
            let brandKor = html.htmlExtractValue(pattern: #"(?s)"brand"\s*:\s*\{.*?"name"\s*:\s*"([^"]+)""#) { $0 }
            
            return ProductDTO(
                id: nil,
                userID: nil,
                platform: 7,
                title: title,
                price: price,
                discountRate: discountRate ?? "0",
                brand: brandKor,
                imagePathURL: imageURL,
                productURL: deepLink?.absoluteString,
                createdAt: nil
            )
        } catch {
            throw ProductSyncError.dataLoadingFailed
        }
    }
}

// https://4910.kr/goods/43182588
