//
//  SupabaseUserInfoManager.swift
//  BestWish
//
//  Created by 이수현 on 6/16/25.
//

import Foundation

import Supabase

protocol SupabaseUserInfoManager {
    /// 유저 정보 불러오기
    func getUserInfo() async throws -> UserDTO
    
    /// 유저 정보 업데이트
    func updateUserInfo(
        profileImageCode: Int?,
        nickname: String?,
        gender: Int?,
        birth: Date?
    ) async throws
}

/// Supabase 유저 정보 매니저
final class SupabaseUserInfoManagerImpl: SupabaseUserInfoManager {
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

    /// 유저 정보 업데이트
    func updateUserInfo(
        profileImageCode: Int?,
        nickname: String?,
        gender: Int?,
        birth: Date?
    ) async throws {
        let userInfo = try await getUserInfo()
        let role = userInfo.role == "GUEST" ? "USER" : userInfo.role
        let updateUserInfo = UserDTO(
            id: userInfo.id,
            email: userInfo.email,
            name: userInfo.name,
            nickname: nickname ?? userInfo.nickname,
            gender: gender ?? userInfo.gender,
            birth: birth ?? userInfo.birth,
            profileImageCode: profileImageCode ?? userInfo.profileImageCode,
            role: role,
            platformSequence: userInfo.platformSequence,
            authProvider: userInfo.authProvider
        )

        do {
            try await supabase
                .from(SupabaseTable.userInfo.rawValue)
                .update(updateUserInfo)
                .eq(UserInfoAttributes.id.rawValue, value: supabase.auth.session.user.id)
                .execute()
        } catch {
            throw SupabaseError.updateError(error)
        }
    }
}
