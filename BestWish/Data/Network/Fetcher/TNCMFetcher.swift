//
//  TNCMFetcher.swift
//  BestWish
//
//  Created by Quarang on 6/27/25.
//

import Foundation
import SwiftSoup

/// 29CM 페쳐
final class TNCMFetcher: ProductDTORepository {
    
    /// 29CM 제품 상세 HTML → ProductDTO 파싱
    func fetchProductDTO(ogUrl: URL?, finalUrl: URL?, html: String?) async throws -> ProductDTO {
        let html = html ?? ""
        let doc = try SwiftSoup.parse(html)

        let title = try doc.title()
        let imageURL = try doc.select("meta[property=og:image]").attr("content")
        let url = try doc.select("meta[property=al:ios:url]").attr("content")

        // 가격 및 할인율 추출
        guard let range = html.range(of: #"totalDiscountedItemPrice.*?\}"#, options: .regularExpression) else { throw ProductSyncError.jsonDecodingFailed }
        let result = String(html[range])
        
        
        let regex = try NSRegularExpression(pattern: "\\d+", options: [])
        let matches = regex.matches(in: result, options: [], range: NSRange(location: 0, length: result.utf16.count))
        let numbers = matches.compactMap { match -> Int? in
            guard let range = Range(match.range, in: result) else { return nil }
            return Int(result[range])
        }
        
        // 브랜드 추출
        guard let brand_range = html.range(of: #"brandNameKor.*?\,"#, options: .regularExpression) else { throw ProductSyncError.jsonDecodingFailed }
        let brand_result = String(html[brand_range])
        
        let brand_regex = try NSRegularExpression(pattern: #"brandNameKor\\":\\"(.*?)\\""#)
        guard let match = brand_regex.firstMatch(in: brand_result, options: [], range: NSRange(location: 0, length: brand_result.utf16.count)),
              let range = Range(match.range(at: 1), in: brand_result) else { throw ProductSyncError.jsonDecodingFailed }
        
        // 초기화
        let price = numbers[0]
        let discountRate = "\(numbers[1])"
        let brand = String(brand_result[range])
        
        return ProductDTO(
            id: nil,
            userID: nil,
            platform: 6,
            title: title,
            price: price,
            discountRate: discountRate,
            brand: brand,
            imagePathURL: imageURL,
            productURL: url,
            createdAt: nil
        )
    }
}


// https://www.29cm.co.kr/products/1951147
