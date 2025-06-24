//
//  WishListUseCase.swift
//  BestWish
//
//  Created by 이수현 on 6/15/25.
//

import Foundation

/// 위시리스트 관련 UseCase 프로토콜
protocol WishListUseCase {

    /// 플랫폼 순서 가져오기
    func getPlatformSequence() async throws -> [Int]

    /// 플랫폼 순서 업데이트
    func updatePlatformSequence(to sequence: [Int]) async throws

    /// 위시리스트 내 플랫폼 가져오기
    func getPlatformsInWishList(isEdit: Bool) async throws ->  [(platform: Int, count: Int)]

    /// 아이템 검색
    func searchWishListItems(query: String?, platform: Int?) async throws -> [ProductEntity]

    /// 위시 아이템 삭제
    func deleteWishListItem(id: UUID) async throws

    /// 위시 아이템 추가
    func addProductToWishList(product: ProductEntity) async throws
}

// MARK: - Protocol 메서드의 파라미터 초기값 설정
extension WishListUseCase {
    func searchWishListItems(query: String? = nil, platform: Int? = nil) async throws -> [ProductEntity] {
        try await searchWishListItems(query: nil, platform: nil)
    }
}

/// 위시리스트 관련 UseCase
final class WishListUseCaseImpl: WishListUseCase {
    private let repository: WishListRepository

    init(repository: WishListRepository) {
        self.repository = repository
    }

    /// 플랫폼 순서 가져오기
    func getPlatformSequence() async throws -> [Int] {
        try await repository.getPlatformSequence()
    }

    /// 플랫폼 순서 업데이트
    func updatePlatformSequence(to sequence: [Int]) async throws {
        try await repository.updatePlatformSequence(to: sequence)
    }

    /// 위시리스트 내 플랫폼 가져오기
    func getPlatformsInWishList(isEdit: Bool) async throws -> [(platform: Int, count: Int)] {
        try await repository.getPlatformsInWishList(isEdit: isEdit)
    }

    /// 아이템 검색
    func searchWishListItems(query: String? = nil, platform: Int? = nil) async throws -> [ProductEntity] {
        try await repository.searchWishListItems(query: query, platform: platform)
    }

    /// 위시 아이템 삭제
    func deleteWishListItem(id: UUID) async throws {
        try await repository.deleteWishListItem(id: id)
    }

    /// 위시 아이템 추가
    func addProductToWishList(product: ProductEntity) async throws {
        try await repository.addProductToWishList(product: product.toDTO())
    }
}
