//
//  ProductSyncUseCase.swift
//  BestWish
//
//  Created by 백래훈 on 6/24/25.
//

import Foundation

protocol ProductSyncUseCase {
    func productToEntity(from sharedText: String) async throws -> ProductEntity
    func entityToModel(from: ProductEntity) -> ProductModel
}

final class ProductSyncUseCaseImpl: ProductSyncUseCase {

    private let repository: ProductSyncRepository

    init(repository: ProductSyncRepository) {
        self.repository = repository
    }

    func productToEntity(from sharedText: String) async throws -> ProductEntity {
        let dto = try await repository.syncProduct(from: sharedText)
        return dto.toEntity()
    }

    func entityToModel(from: ProductEntity) -> ProductModel {
        return from.toModel()
    }
}
