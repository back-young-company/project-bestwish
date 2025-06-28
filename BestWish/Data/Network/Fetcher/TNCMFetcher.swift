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
        let doc = try SwiftSoup.parse(html ?? "")
        
        print(doc.body())

        let title = try doc.title()
        let imageURL = try doc.select("meta[property=og:image]").attr("content")
        let price = try doc.select("script:contains(__next_f.push)").first()
        let brand = try doc.select("p.title-text").first()?.text()
        let url = try doc.select("meta[property=al:ios:url]").attr("content")
        
        
        print(ProductDTO(
            id: nil,
            userID: nil,
            platform: 6,
            title: title,
            price: 0,
            discountRate: nil,
            brand: brand,
            imagePathURL: imageURL,
            productURL: url,
            createdAt: nil
        ))
    
        throw ProductSyncError.invalidProductData
    }
}


// https://www.29cm.co.kr/products/1951147
