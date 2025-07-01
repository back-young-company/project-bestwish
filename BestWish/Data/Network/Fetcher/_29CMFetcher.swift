//
//  _29CMFetcher.swift
//  BestWish
//
//  Created by Quarang on 6/27/25.
//

import Foundation

import SwiftSoup

/// 29CM 페쳐
final class _29CMFetcher: ProductDTORepository {
    /// 29CM 제품 상세 HTML → ProductDTO 파싱
    func fetchProductDTO(deepLink: URL?, productURL: URL?, html: String?) async throws -> ProductDTO {
        guard let html else {
            throw ProductSyncError.htmlParsingFailed
        }
        do {
            let doc = try SwiftSoup.parse(html)

            // SwiftSoup으로 파싱 헤더에 데이터가 있을 때만 가능
            let title = try doc.title()
            let imageURL = try doc.select("meta[property=og:image]").attr("content")
            let url = try doc.select("meta[property=al:ios:url]").attr("content")
            
            // JsonData 혹은 Body에 필요한 데이터가 있는 경우 추출
            let nums = html.extractNumbers(inRangeMatching: #"totalDiscountedItemPrice.*?\}"#)
            let price = nums?.first
            let discountRate = String(nums?.last ?? 0)
            let brandKor = html.htmlExtractValue(pattern: #"brandNameKor\\":\\"(.*?)\\""#) { $0 }
            
            return ProductDTO(
                id: nil,
                userID: nil,
                platform: 6,
                title: title,
                price: price,
                discountRate: discountRate,
                brand: brandKor,
                imagePathURL: imageURL,
                productURL: url,
                createdAt: nil
            )
        } catch {
            throw ProductSyncError.dataLoadingFailed
        }
    }
}


// https://www.29cm.co.kr/products/1951147
