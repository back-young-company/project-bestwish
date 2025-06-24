//
//  ProductSyncRepositoryImpl.swift
//  BestWish
//
//  Created by 백래훈 on 6/24/25.
//

import Foundation

final class ProductSyncRepositoryImpl: ProductSyncRepository {

    private let manager: ProductSyncManager

    init(manager: ProductSyncManager) {
        self.manager = manager
    }

    func syncProduct(from sharedText: String) async throws -> ProductDTO {
        return try await manager.fetchProductSync(from: sharedText).1
    }

}
