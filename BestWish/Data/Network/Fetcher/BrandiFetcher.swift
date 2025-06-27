//
//  BrandiFetcher.swift
//  BestWish
//
//  Created by Quarang on 6/27/25.
//

import Foundation
import SwiftSoup

/// 브랜디 Fetcher
final class BrandiFetcher: ProductDTORepository {
    
    /// 브랜디 제품 상세 HTML → ProductDTO 파싱
    func fetchProductDTO(ogUrl: URL?, finalUrl: URL?, html: String?) async throws -> ProductDTO {
        let doc = try SwiftSoup.parse(html ?? "")
        
        let title = try doc.title()
        let imageURL = try doc.select("meta[property=og:image]").attr("content")
        let brand = ((((try? JSONSerialization.jsonObject(with: (try doc.select("script#prefetch-data").first()?.html().data(using: .utf8) ?? Data()))) as? [String: Any])?["data"] as? [String: Any])?["seller"] as? [String: Any])?["name"] as? String ?? ""
        let discountRate = ((try? JSONSerialization.jsonObject(with: SwiftSoup.parse(html ?? "").select("script#prefetch-data").first()!.html().data(using: .utf8)!) as? [String: Any])?["data"] as? [String: Any])?["sale_percent"] as? Int ?? 0
        let price = Int(
            try doc.select("meta[property=og:title]").attr("content")
                .components(separatedBy: CharacterSet.decimalDigits.inverted)
                .joined()
        )
        
        return ProductDTO(
            id: nil,
            userID: nil,
            platform: 5,
            title: title,
            price: price,
            discountRate: "\(discountRate)",
            brand: brand,
            imagePathURL: imageURL,
            productURL: ogUrl?.absoluteString,
            createdAt: nil
        )
    }
}

// https://www.brandi.co.kr/products/174895988?search-word=%EB%B9%84%ED%82%A4%EB%8B%88
