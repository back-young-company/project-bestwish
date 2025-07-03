//
//  ProductSyncUseCase.swift
//  BestWish
//
//  Created by 백래훈 on 6/24/25.
//

import Foundation

/// 상품 정보 동기 관련 유즈 케이스 선언부
public protocol ProductSyncUseCase {
    /// ProductEntity 전달
    func sendProductEntity(from sharedText: String) async throws -> ProductEntity
}

/// 상품 정보 동기 관련 유즈 케이스 구현체
public final class ProductSyncUseCaseImpl: ProductSyncUseCase {

    private let repository: ProductSyncRepository

    public init(repository: ProductSyncRepository) {
        self.repository = repository
    }

    /// ProductEntity 전달
    public func sendProductEntity(from sharedText: String) async throws -> ProductEntity {
        return try await repository.syncProduct(from: sharedText)
    }
}
