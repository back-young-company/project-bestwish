//
//  WishListRepositoryImpl.swift
//  BestWish
//
//  Created by 이수현 on 6/15/25.
//

import Foundation

/// 위시리스트 관련 레포지토리
final class WishListRepositoryImpl: WishListRepository {

    // FIXME: SupabaseManager 네이밍 변경 필요
    private let manager: SupabaseManager
    private let userInfoManager: SupabaseUserInfoManager

    init(manager: SupabaseManager, userInfoManager: SupabaseUserInfoManager) {
        self.manager = manager
        self.userInfoManager = userInfoManager
    }

    /// 플랫폼 순서 가져오기
    func getPlatformSequence() async throws -> [Int] {
        do {
            return try await manager.getPlatformSequence()
                .platformSequence
                .map { Int($0) }
        } catch let error as SupabaseError {
            throw AppError.supabaseError(error)
        }
    }

    /// 플랫폼 순서 업데이트
    func updatePlatformSequence(to sequence: [Int]) async throws {
        do {
            try await manager.updatePlatformSequence(to: sequence.map { Int16($0) })
        } catch let error as SupabaseError {
            throw AppError.supabaseError(error)
        }
    }

    /// 위시리스트 내 플랫폼 가져오기
    func getPlatformsInWishList(isEdit: Bool) async throws -> [(platform: Int, count: Int)] {
        let userInfo = try await userInfoManager.getUserInfo()
        
        do {
            return try await manager.getPlatformsInWishList(userInfo: userInfo, isEdit: isEdit)
        } catch let error as SupabaseError {
            throw AppError.supabaseError(error)
        }
    }

    /// 아이템 검색
    func searchWishListItems(query: String?, platform: Int?) async throws -> [ProductEntity] {
        do {
            let result = try await manager.searchWishListItems(query: query, platform: platform)
            return try result.map { try convertToProduct(from: $0) }
        } catch let error as SupabaseError {
            throw AppError.supabaseError(error)
        } catch let error as MappingError {
            throw AppError.mappingError(error)
        }
    }

    /// 위시 아이템 삭제
    func deleteWishListItem(id: UUID) async throws {
        do {
            try await manager.deleteWishListItem(id: id)
        } catch let error as SupabaseError {
            throw AppError.supabaseError(error)
        }
    }

    /// 위시 아이템 추가
    func addProductToWishList(product: ProductDTO) async throws {
        do {
            try await manager.addProductToWishList(
                product: product //convertToProductDTO(from: product)
            )
        } catch let error as SupabaseError {
            throw AppError.supabaseError(error)
        }
    }
}

// MARK: - DTO -> Entity 매핑
extension WishListRepositoryImpl {
    /// ProductDTO -> Product Entity 매핑
    private func convertToProduct(from dto: ProductDTO) throws -> ProductEntity {
        guard let id = dto.id,
              let userID = dto.userID,
              let platform = dto.platform,
              let title = dto.title,
              let price = dto.price,
              let discountRate = dto.discountRate,
              let brand = dto.brand,
              let imagePathURL = dto.imagePathURL,
              let productURL = dto.productURL,
              let createdAt = dto.createdAt
        else {
            throw MappingError.productDTOToProduct
        }

        return ProductEntity(
            id: id,
            userID: userID,
            platform: platform,
            title: title,
            price: price,
            discountRate: discountRate,
            brand: brand,
            imagePathURL: imagePathURL,
            productURL: productURL,
            createdAt: createdAt
        )
    }

    /// ProductMetadata -> ProductDTO 매핑
    private func convertToProductDTO(from entity: ProductMetadata) -> ProductDTO {
        ProductDTO(
            id: UUID(),
            userID: nil,
            platform: entity.platform,
            title: entity.productName,
            price: entity.price,
            discountRate: entity.discountRate,
            brand: entity.brandName,
            imagePathURL: entity.imageURL,
            productURL: entity.productURL,
            createdAt: nil
        )
    }
}
