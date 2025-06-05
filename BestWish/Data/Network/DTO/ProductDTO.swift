//
//  ProductDTO.swift
//  BestWish
//
//  Created by 이수현 on 6/5/25.
//

import Foundation

struct ProductDTO: Codable {
    let id: UUID
    let userID: UUID
    let platform: Int?
    let title: String?
    let price: Int?
    let imagePathURL: String?
    let productURL: String?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case platform
        case title
        case price
        case imagePathURL = "image_path_url"
        case productURL = "product_url"
        case createdAt = "created_at"
    }
}
