//
//  ProductSyncRepository.swift
//  BestWish
//
//  Created by 백래훈 on 6/24/25.
//

import Foundation

protocol ProductSyncRepository {
    func syncProduct(from sharedText: String) async throws -> ProductDTO
}
