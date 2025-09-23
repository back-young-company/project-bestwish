//
//  SupabaseUserInfoManagerImpl.swift
//  BestWishData
//
//  Created by 이수현 on 9/23/25.
//

import Foundation

public import Supabase

/// Supabase 유저 정보 매니저
public final class SupabaseUserInfoManagerImpl: SupabaseUserInfoManager {
    private let supabase: SupabaseClient

    public init(_ client: SupabaseClient) {
        supabase = client
    }

    /// 유저 정보 불러오기
    public func getUserInfo() async throws -> UserDTO {
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
    public func updateUserInfo(
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
