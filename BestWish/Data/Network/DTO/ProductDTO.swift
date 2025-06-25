//
//  ProductDTO.swift
//  BestWish
//
//  Created by 이수현 on 6/5/25.
//

import Foundation

/// 위시리스트 제품 DTO
struct ProductDTO: Codable {
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

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case platform
        case title
        case price
        case discountRate = "discount_rate"
        case brand
        case imagePathURL = "image_path_url"
        case productURL = "product_url"
        case createdAt = "created_at"
    }

    func toEntity() -> ProductEntity {
        return ProductEntity(
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

/// 플랫폼 DTO
struct PlatformDTO: Codable {
    let platform: Int16
}
