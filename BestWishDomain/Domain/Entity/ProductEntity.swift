//
//  ProductEntity.swift
//  BestWish
//
//  Created by 이수현 on 6/15/25.
//

import Foundation

/// 위시 아이템 엔티티
public struct ProductEntity {
    public let id: UUID?
    public let userID: UUID?
    public let platform: Int?
    public let title: String?
    public let price: Int?
    public let discountRate: String?
    public let brand: String?
    public let imagePathURL: String?
    public let productURL: String?
    public let createdAt: Date?

    public init(
        id: UUID?,
        userID: UUID?,
        platform: Int?,
        title: String?,
        price: Int?,
        discountRate: String?,
        brand: String?,
        imagePathURL: String?,
        productURL: String?,
        createdAt: Date?
    ) {
        self.id = id
        self.userID = userID
        self.platform = platform
        self.title = title
        self.price = price
        self.discountRate = discountRate
        self.brand = brand
        self.imagePathURL = imagePathURL
        self.productURL = productURL
        self.createdAt = createdAt
    }
}
