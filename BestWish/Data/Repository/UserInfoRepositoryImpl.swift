//
//  UserInfoRepositoryImpl.swift
//  BestWish
//
//  Created by 이수현 on 6/16/25.
//

import Foundation

final class UserInfoRepositoryImpl: UserInfoRepository {
    private let manager: SupabaseUserInfoManager

    init(manager: SupabaseUserInfoManager) {
        self.manager = manager
    }

    func getUserInfo() async throws -> User {
        do {
            let result = try await manager.getUserInfo()
            return convertToUser(from: result)
        } catch let error as SupabaseError {
            throw AppError.supabaseError(error)
        }
    }

    func updateUserInfo(
        profileImageCode: Int?,
        nickname: String?,
        gender: Int?,
        birth: Date?
    ) async throws {
        do {
            try await manager.updateUserInfo(
                profileImageCode: profileImageCode,
                nickname: nickname,
                gender: gender,
                birth: birth
            )
        } catch let error as SupabaseError {
            throw AppError.supabaseError(error)
        }
    }
}

extension UserInfoRepositoryImpl {
    private func convertToUser(from dto: UserDTO) -> User {

        // TODO: 리펙토링하기
        var provider = ""
        if dto.authProvider == "apple" {
            provider = "애플"
        } else if dto.authProvider == "kakao" {
            provider = "카카오"
        }
        
        return User(
            name: dto.name,
            email: dto.email,
            nickname: dto.nickname,
            gender: dto.gender,
            birth: dto.birth,
            profileImageCode: dto.profileImageCode ?? 0,
            authProvider: provider
        )
    }
}
