//
//  WishListRepository.swift
//  BestWish
//
//  Created by 이수현 on 6/14/25.
//

import Foundation

/// 위시리스트 관련 레포지토리 프로토콜
protocol WishListRepository {

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
