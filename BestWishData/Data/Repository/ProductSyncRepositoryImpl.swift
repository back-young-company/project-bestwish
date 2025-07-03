//
//  ProductSyncRepositoryImpl.swift
//  BestWish
//
//  Created by 백래훈 on 6/24/25.
//

import BestWishDomain
import Foundation

/// 상품 정보 동기 관련 레포지토리 구현체
public final class ProductSyncRepositoryImpl: ProductSyncRepository {

    private let manager: ProductSyncManager

    public init(manager: ProductSyncManager) {
        self.manager = manager
    }

    /// 상품 동기 메서드
    public func syncProduct(from sharedText: String) async throws -> ProductEntity {
        return try await manager.fetchProductSync(from: sharedText).toEntity()
    }
}
