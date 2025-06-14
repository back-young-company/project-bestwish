//
//  SupabaseManager.swift
//  BestWish
//
//  Created by 이수현 on 6/5/25.
//

import Foundation
import Supabase

final class SupabaseManager {
    private let supabase: SupabaseClient

    init() {
        supabase = SupabaseClient(
            supabaseURL: Bundle.main.supabaseURL,
            supabaseKey: Bundle.main.apiKey
        )
    }

    // 플랫폼 순서 조회
    func getPlatformSequence() async throws -> [Int] {
        try await supabase
            .from(SupabaseTable.userInfo.rawValue)
            .select(UserInfoAttributes.platform_sequence.rawValue)
            .eq(UserInfoAttributes.id.rawValue, value: supabase.auth.session.user.id)
            .execute()
            .value
    }

    // 플랫폼 순서 편집
    func updatePlatformSequence(to sequence: [Int]) async throws {
        try await supabase
            .from(SupabaseTable.userInfo.rawValue)
            .update([UserInfoAttributes.platform_sequence.rawValue: sequence])
            .eq(UserInfoAttributes.id.rawValue, value: supabase.auth.session.user.id)
            .execute()
    }

    // 위시 리스트에 포함된 플랫폼 조회
    func getPlatformsInWishList() async throws -> [Int] {
        let result: [Int] = try await supabase
            .from(SupabaseTable.product.rawValue)
            .select(ProductAttributes.platform.rawValue)
            .eq(ProductAttributes.user_id.rawValue, value: supabase.auth.session.user.id)
            .execute()
            .value

        return Array(Set(result))
    }

    // 위시 아이템 검색
    func searchWishListItems(query: String, platform: Int?) async throws -> [ProductDTO] {
        var builder = try await supabase
            .from(SupabaseTable.product.rawValue)
            .select()
            .eq(ProductAttributes.user_id.rawValue, value: supabase.auth.session.user.id)
            .ilike(ProductAttributes.title.rawValue, pattern: "%\(query)%") // ilike: 대소문자 구분 X

        if let platform {
            builder = builder.eq(ProductAttributes.platform.rawValue, value: platform)
        }

        let result: [ProductDTO] = try await builder
            .execute()
            .value

        return result
    }

    // 위시 아이템 삭제
    func deleteWishListItem(id: UUID) async throws {
        try await supabase
            .from(SupabaseTable.product.rawValue)
            .delete()
            .eq(ProductAttributes.user_id.rawValue, value: supabase.auth.session.user.id)
            .eq(ProductAttributes.id.rawValue, value: id)
            .execute()
    }

    // 위시 아이템 등록
    func addProductToWishList(product: ProductDTO) async throws {
        try await supabase
            .from(SupabaseTable.product.rawValue)
            .insert(product)
            .execute()
        return
    }
}
