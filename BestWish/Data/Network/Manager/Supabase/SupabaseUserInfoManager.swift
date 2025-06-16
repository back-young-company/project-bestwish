//
//  SupabaseUserInfoManager.swift
//  BestWish
//
//  Created by 이수현 on 6/16/25.
//

import Foundation
import Supabase

final class SupabaseUserInfoManager {
    private let supabase: SupabaseClient

    init() {
        supabase = SupabaseClient(
            supabaseURL: Bundle.main.supabaseURL,
            supabaseKey: Bundle.main.apiKey
        )
    }

    /// 유저 정보 불러오기
    func getUserInfo() async throws -> UserDTO {
        do {
            let userID = try await supabase.auth.session.user.id

            return try await supabase
                .from(SupabaseTable.userInfo.rawValue)
                .select()
                .eq(UserInfoAttributes.id.rawValue, value: userID)
                .single()
                .execute()
                .value
        } catch {
            throw SupabaseError.selectError(error)
        }
    }
}
