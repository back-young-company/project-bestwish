//
//  SupabaseManager.swift
//  BestWish
//
//  Created by 이수현 on 6/5/25.
//

import Foundation

import Supabase

/// 위시 리스트 관련 매니저
final class SupabaseManager {
    private let supabase: SupabaseClient

    init() {
        supabase = SupabaseClient(
            supabaseURL: Bundle.main.supabaseURL,
            supabaseKey: Bundle.main.apiKey
        )
    }

    /// 플랫폼 순서 조회
    func getPlatformSequence() async throws -> PlatformSequenceDTO {
        do {
            return try await supabase
                .from(SupabaseTable.userInfo.rawValue)
                .select(UserInfoAttributes.platform_sequence.rawValue)
                .eq(UserInfoAttributes.id.rawValue, value: supabase.auth.session.user.id)
                .single()
                .execute()
                .value
        } catch {
            throw SupabaseError.selectError(error)
        }
    }

    /// 플랫폼 순서 편집
    func updatePlatformSequence(to sequence: [Int16]) async throws {
        do {
            try await supabase
                .from(SupabaseTable.userInfo.rawValue)
                .update([UserInfoAttributes.platform_sequence.rawValue: sequence])
                .eq(UserInfoAttributes.id.rawValue, value: supabase.auth.session.user.id)
                .execute()
        } catch {
            throw SupabaseError.updateError(error)
        }
    }

    /// 위시 리스트에 포함된 플랫폼 조회
    func getPlatformsInWishList(userInfo: UserDTO, isEdit: Bool) async throws -> [(platform: Int, count: Int)] {
        let sequence = userInfo.platformSequence ?? []
        do {
            // product 테이블에서 사용자와 일치하는 platform들만 가져오기
            let result: [PlatformDTO] = try await supabase
                .from(SupabaseTable.product.rawValue)
                .select(ProductAttributes.platform.rawValue)
                .eq(ProductAttributes.user_id.rawValue, value: supabase.auth.session.user.id)
                .execute()
                .value
            let platforms = result.map { Int($0.platform) }

            let platformCountDict = platforms.reduce(into: [:]) { result, platform in
                result[platform, default: 0] += 1
            }

            // sequence 순서에 따라 정렬 및 매핑
            let sortedResult: [(Int, Int)]
            if isEdit {
                sortedResult = sequence.map { platform -> (platform: Int, count: Int) in
                    guard let count = platformCountDict[platform] else {
                        return (platform: platform, count: 0)
                    }
                    return (platform: platform, count: count)
                }
            } else {
                sortedResult = sequence.compactMap { platform -> (platform: Int, count: Int)? in
                    guard let count = platformCountDict[platform] else { return nil }
                    return (platform: platform, count: count)
                }
            }
            return sortedResult
        } catch {
            throw SupabaseError.selectError(error)
        }
    }

    /// 위시 아이템 검색
    func searchWishListItems(query: String?, platform: Int?) async throws -> [ProductDTO] {
        do {
            var builder = try await supabase
                .from(SupabaseTable.product.rawValue)
                .select()
                .eq(ProductAttributes.user_id.rawValue, value: supabase.auth.session.user.id)

            if let query {
                // ilike: 대소문자 구분 X
                builder = builder.ilike(ProductAttributes.title.rawValue, pattern: "%\(query)%")
            }

            if let platform {
                builder = builder.eq(ProductAttributes.platform.rawValue, value: platform)
            }

            return try await builder
                .order(ProductAttributes.created_at.rawValue, ascending: false)
                .execute()
                .value
        } catch {
            throw SupabaseError.selectError(error)
        }
    }

    /// 위시 아이템 삭제
    func deleteWishListItem(id: UUID) async throws {
        do {
            try await supabase
                .from(SupabaseTable.product.rawValue)
                .delete()
                .eq(ProductAttributes.user_id.rawValue, value: supabase.auth.session.user.id)
                .eq(ProductAttributes.id.rawValue, value: id)
                .execute()
        } catch {
            throw SupabaseError.deleteError(error)
        }
    }

    /// 위시 아이템 등록
    func addProductToWishList(product: ProductDTO) async throws {
        do {
            let userID = try await supabase.auth.session.user.id
            let product = ProductDTO(
                id: product.id,
                userID: userID,
                platform: product.platform,
                title: product.title,
                price: product.price,
                discountRate: product.discountRate,
                brand: product.brand,
                imagePathURL: product.imagePathURL,
                productURL: product.productURL,
                createdAt: nil
            )

            try await supabase
                .from(SupabaseTable.product.rawValue)
                .insert(product)
                .execute()
        } catch {
            throw SupabaseError.insertError(error)
        }
    }
}
