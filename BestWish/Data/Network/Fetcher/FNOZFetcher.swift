//
//  FNOZFetcher.swift
//  BestWish
//
//  Created by Quarang on 6/28/25.
//

import Foundation
import SwiftSoup

/// 4910 페쳐
final class FNOZFetcher: ProductDTORepository {
    
    /// 크림 제품 상세 HTML → ProductDTO 파싱
    func fetchProductDTO(ogUrl: URL?, finalUrl: URL?, html: String?) async throws -> ProductDTO {
        let html = html ?? ""
        let doc = try SwiftSoup.parse(html)

        let title = try doc.title()
        let imageURL = try doc.select("img[alt='상품 썸네일'][data-nimg=fill]").first()?.attr("abs:src")
        
        let productId = ogUrl?.absoluteString.replacingOccurrences(of: "https://4910.kr/goods/", with: "") ?? ""
        
        // 가격
        let price = Int(
            (html.range(
                of: #""discounted_price"\s*:\s*(\d+)"#,
                options: .regularExpression
            )
            .flatMap { String(html[$0]) } ?? "")
            .replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        )

        // 할인율
        let discount = html.range(of: #"\"extra_discount\"\s*:\s*\{[^}]*?\"discount_rate\"\s*:\s*(\d+)"#, options: .regularExpression)
            .flatMap { String(html[$0]) }?
            .replacingOccurrences(of: "[^0-9]", with: "",
                                 options: .regularExpression)
        
        // 브랜드
        let brandKor = html.range(
            of: #"(?s)"brand"\s*:\s*\{.*?"name"\s*:\s*\"([^\"]+)""#,
            options: [.regularExpression]
        )
        .flatMap { String(html[$0]) }?
        .replacingOccurrences(
            of: #"(?s).*?"name"\s*:\s*"|""#,
            with: "",
            options: [.regularExpression]
        )
        
        return ProductDTO(
            id: nil,
            userID: nil,
            platform: 8,
            title: title,
            price: price,
            discountRate: discount,
            brand: brandKor,
            imagePathURL: imageURL,
            productURL: "aglo://webview?url=https://4910.kr/goods/\(productId)",
            createdAt: nil
        )
    }
}

// https://4910.kr/goods/43182588
