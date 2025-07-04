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
    private let firebaseAnalyticsManager: FirebaseAnalyticsManager

    public init(manager: ProductSyncManager, firebaseAnalyticsManager: FirebaseAnalyticsManager) {
        self.manager = manager
        self.firebaseAnalyticsManager = firebaseAnalyticsManager
    }

    /// 상품 동기 메서드
    public func syncProduct(from sharedText: String) async throws -> ProductEntity {
        do {
            return try await manager.fetchProductSync(from: sharedText).toEntity()
        } catch let error as ProductSyncError {
            switch error {
            case let .invaildURL(data):
                firebaseAnalyticsManager.logProductSync(parameters: data)
            case let .platformDetectionFailed(data):
                firebaseAnalyticsManager.logProductSync(parameters: data)
            case let .redirectionFailed(data):
                firebaseAnalyticsManager.logProductSync(parameters: data)
            case let .urlExtractionFailed(data):
                firebaseAnalyticsManager.logProductSync(parameters: data)
            default:
                break
            }
        }
        throw ProductSyncError.unknown
    }
}
