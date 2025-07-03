//
//  UserInfoRepositoryImpl.swift
//  BestWish
//
//  Created by 이수현 on 6/16/25.
//

import BestWishDomain
import Foundation

/// 유저 정보 관련 레포지토리
public final class UserInfoRepositoryImpl: UserInfoRepository {
    private let manager: SupabaseUserInfoManager

    public init(manager: SupabaseUserInfoManager) {
        self.manager = manager
    }

    /// 유저 정보 불러오기
    public func getUserInfo() async throws -> UserEntity {
        do {
            let result = try await manager.getUserInfo()
            return convertToUser(from: result)
        } catch let error as SupabaseError {
            throw AppError.supabaseError(error)
        }
    }

    /// 유저 정보 업데이트
    public func updateUserInfo(
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

// MARK: - DTO -> Entity 매핑
extension UserInfoRepositoryImpl {

    /// UserDTO -> User
    private func convertToUser(from dto: UserDTO) -> UserEntity {
        UserEntity(
            name: dto.name,
            email: dto.email,
            nickname: dto.nickname,
            gender: dto.gender,
            birth: dto.birth,
            profileImageCode: dto.profileImageCode ?? 0,
            authProvider: SocialType(provider: dto.authProvider)?.korean
        )
    }
}
