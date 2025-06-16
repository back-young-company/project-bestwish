//
//  WishListRepositoryImpl.swift
//  BestWish
//
//  Created by 이수현 on 6/15/25.
//

import Foundation

final class WishListRepositoryImpl: WishListRepositroy {

    private let manager: SupabaseManager

    init(manager: SupabaseManager) {
        self.manager = manager
    }

    func getPlatformSequence() async throws -> [Int] {
        try await manager.getPlatformSequence()
            .platformSequence
            .map { Int($0) }
    }

    func updatePlatformSequence(to sequence: [Int]) async throws {
        try await manager.updatePlatformSequence(to: sequence.map { Int16($0) })
    }

    func getPlatformsInWishList() async throws -> [Int] {
        let result = try await manager.getPlatformsInWishList()
        return Array(Set(result.map { Int($0.platform) }))
    }

    // TODO: Error Handling
    func searchWishListItems(query: String, platform: Int?) async throws -> [Product] {
        let result = try await manager.searchWishListItems(query: query, platform: platform)
        print(result)
        return try result.map { try convertToProduct(from: $0) }
    }

    func deleteWishListItem(id: UUID) async throws {
        try await manager.deleteWishListItem(id: id)
    }

    // TODO: Entity -> DTO
    func addProductToWishList(product: ProductMetadata) async throws {
        try await manager.addProductToWishList(
            product: convertToProductDTO(from: product)
        )
    }
}

extension WishListRepositoryImpl {
    private func convertToProduct(from dto: ProductDTO) throws -> Product {
        guard let userID = dto.userID,
              let platform = dto.platform,
              let title = dto.title,
              let price = dto.price,
              let discountRate = dto.discountRate,
              let brand = dto.brand,
              let imagePathURL = dto.imagePathURL
        else {
            // TODO: 매핑 에러 처리
            throw DummyNetworkError.invalidURL
        }

        return Product(
            id: dto.id,
            userID: userID,
            platform: platform,
            title: title,
            price: price,
            discountRate: discountRate,
            brand: brand,
            imagePathURL: imagePathURL,
            productURL: dto.productURL,
            createdAt: dto.createdAt
        )
    }

    private func convertToProductDTO(from entity: ProductMetadata) -> ProductDTO {
        ProductDTO(
            id: UUID(),
            userID: nil,
            platform: entity.platform,
            title: entity.productName,
            price: entity.price,
            discountRate: entity.discountRate,
            brand: entity.brandName,
            imagePathURL: entity.imageURL,
            productURL: entity.productURL
        )
    }
}
