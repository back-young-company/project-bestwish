//
//  WishListRepository.swift
//  BestWish
//
//  Created by 이수현 on 6/14/25.
//

import Foundation

protocol WishListRepository {
    func getPlatformSequence() async throws -> [Int]
    func updatePlatformSequence(to sequence: [Int]) async throws
    func getPlatformsInWishList() async throws -> [Int]
    func searchWishListItems(query: String?, platform: Int?) async throws -> [Product]
    func deleteWishListItem(id: UUID) async throws
    func addProductToWishList(product: ProductMetadata) async throws
}
