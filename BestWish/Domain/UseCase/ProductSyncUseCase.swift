//
//  ProductSyncUseCase.swift
//  BestWish
//
//  Created by 백래훈 on 6/24/25.
//

import Foundation

/// 상품 정보 동기 관련 유즈 케이스 선언부
protocol ProductSyncUseCase {
    /// ProductDTO -> ProductEntity 변환
    func productDTOToEntity(from sharedText: String) async throws -> ProductEntity
}

/// 상품 정보 동기 관련 유즈 케이스 구현체
final class ProductSyncUseCaseImpl: ProductSyncUseCase {

    private let repository: ProductSyncRepository

    init(repository: ProductSyncRepository) {
        self.repository = repository
    }

    /// ProductDTO -> ProductEntity 변환
    func productDTOToEntity(from sharedText: String) async throws -> ProductEntity {
        let dto = try await repository.syncProduct(from: sharedText)
        return dto.toEntity()
    }
}
