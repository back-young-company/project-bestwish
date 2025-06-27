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
    func fetchProductDTO(ogUrl: URL?, finalUrl: URL?, html: String?) async throws -> ProductDTO {
        let doc = try SwiftSoup.parse(html ?? "")

        let title = try doc.select("p.sub-title").first()?.text() ?? ""
        let imageURL = try doc.select("img.full_width.image").first()?.attr("abs:src") ?? ""
        let priceText  = try doc.select("p.price").first()?.text() ?? ""
        let price = Int(priceText.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression))
        let brand = try doc.select("p.title-text").first()?.text()
        
        return ProductDTO(
            id: nil,
            userID: nil,
            platform: 1,
            title: title,
            price: price,
            discountRate: "0",
            brand: brand,
            imagePathURL: imageURL,
            productURL: ogUrl?.absoluteString,
            createdAt: nil
        )
    }
}


// [KREAM] Asics x Cecilie Bahnsen Gel-Cumulus 16 Gray https://kream.co.kr/products/533996
