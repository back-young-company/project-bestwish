//
//  WishListUseCase.swift
//  BestWish
//
//  Created by 이수현 on 6/15/25.
//

import Foundation

protocol WishListUseCase {
    func getPlatformSequence() async throws -> [Int]
    func updatePlatformSequence(to sequence: [Int]) async throws
    func getPlatformsInWishList() async throws -> [Int]
    func searchWishListItems(query: String?, platform: Int?) async throws -> [Product]
    func deleteWishListItem(id: UUID) async throws
    func addProductToWishList(product: ProductMetadata) async throws
}

extension WishListUseCase {
    func searchWishListItems(query: String? = nil, platform: Int? = nil) async throws -> [Product] {
        try await searchWishListItems(query: nil, platform: nil)
    }
}

final class WishListUseCaseImpl: WishListUseCase {
    private let repository: WishListRepositroy

    init(repository: WishListRepositroy) {
        self.repository = repository
    }

    func getPlatformSequence() async throws -> [Int] {
        try await repository.getPlatformSequence()
    }

    func updatePlatformSequence(to sequence: [Int]) async throws {
        try await repository.updatePlatformSequence(to: sequence)
    }

    func getPlatformsInWishList() async throws -> [Int] {
         try await repository.getPlatformsInWishList()
    }

    func searchWishListItems(query: String? = nil, platform: Int? = nil) async throws -> [Product] {
        try await repository.searchWishListItems(query: query, platform: platform)
    }

    func deleteWishListItem(id: UUID) async throws {
        try await repository.deleteWishListItem(id: id)
    }

    func addProductToWishList(product: ProductMetadata) async throws {
        try await repository.addProductToWishList(product: product)
    }
}
