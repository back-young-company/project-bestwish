//
//  ProductEntity.swift
//  BestWish
//
//  Created by 이수현 on 6/15/25.
//

import Foundation

/// 위시 아이템 엔티티
struct ProductEntity {
    let id: UUID?
    let userID: UUID?
    let platform: Int?
    let title: String?
    let price: Int?
    let discountRate: String?
    let brand: String?
    let imagePathURL: String?
    let productURL: String?
    let createdAt: Date?

    /// ProductEntity -> ProductDTO 변환
    func toDTO() -> ProductDTO {
        return ProductDTO(
            id: id,
            userID: userID,
            platform: platform,
            title: title,
            price: price,
            discountRate: discountRate,
            brand: brand,
            imagePathURL: imagePathURL,
            productURL: productURL,
            createdAt: createdAt
        )
    }
}
