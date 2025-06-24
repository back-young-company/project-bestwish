//
//  WishListRepositoryImpl.swift
//  BestWish
//
//  Created by 이수현 on 6/15/25.
//

import Foundation

final class WishListRepositoryImpl: WishListRepository {

    // FIXME: SupabaseManager 네이밍 변경 필요
    private let manager: SupabaseManager
    private let userInfoManager: SupabaseUserInfoManager

    init(manager: SupabaseManager, userInfoManager: SupabaseUserInfoManager) {
        self.manager = manager
        self.userInfoManager = userInfoManager
    }

    func getPlatformSequence() async throws -> [Int] {
        do {
            return try await manager.getPlatformSequence()
                .platformSequence
                .map { Int($0) }
        } catch let error as SupabaseError {
            throw AppError.supabaseError(error)
        }
    }

    func updatePlatformSequence(to sequence: [Int]) async throws {
        do {
            try await manager.updatePlatformSequence(to: sequence.map { Int16($0) })
        } catch let error as SupabaseError {
            throw AppError.supabaseError(error)
        }
    }

    func getPlatformsInWishList(isEdit: Bool) async throws -> [(platform: Int, count: Int)] {
        let userInfo = try await userInfoManager.getUserInfo()
        
        do {
            return try await manager.getPlatformsInWishList(userInfo: userInfo, isEdit: isEdit)
        } catch let error as SupabaseError {
            throw AppError.supabaseError(error)
        }
    }

    func searchWishListItems(query: String?, platform: Int?) async throws -> [Product] {
        do {
            let result = try await manager.searchWishListItems(query: query, platform: platform)
            return try result.map { try convertToProduct(from: $0) }
        } catch let error as SupabaseError {
            throw AppError.supabaseError(error)
        } catch let error as MappingError {
            throw AppError.mappingError(error)
        }
    }

    func deleteWishListItem(id: UUID) async throws {
        do {
            try await manager.deleteWishListItem(id: id)
        } catch let error as SupabaseError {
            throw AppError.supabaseError(error)
        }
    }

    func addProductToWishList(product: ProductMetadata) async throws {
        do {
            try await manager.addProductToWishList(
                product: convertToProductDTO(from: product)
            )
        } catch let error as SupabaseError {
            throw AppError.supabaseError(error)
        }
    }
}

extension WishListRepositoryImpl {
    private func convertToProduct(from dto: ProductDTO) throws -> Product {
        guard let userID = dto.userID,
              let platform = dto.platform,
              let title = dto.title,
              let price = dto.price,
              let discountRate = dto.discountRate,
              let brand = dto.brand,
              let imagePathURL = dto.imagePathURL
        else {
            throw MappingError.productDTOToProduct
        }

        return Product(
            id: dto.id,
            userID: userID,
            platform: platform,
            title: title,
            price: price,
            discountRate: discountRate,
            brand: brand,
            imagePathURL: imagePathURL,
            productURL: dto.productURL,
            createdAt: dto.createdAt
        )
    }

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
