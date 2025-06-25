//
//  ProductSyncRepository.swift
//  BestWish
//
//  Created by 백래훈 on 6/24/25.
//

import Foundation

/// 상품 정보 동기 관련 레포지토리 선언부
protocol ProductSyncRepository {
    /// 상품 동기 메서드
    func syncProduct(from sharedText: String) async throws -> ProductDTO
}
