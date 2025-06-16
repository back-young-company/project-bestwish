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
            return try convertToUser(from: result)
        } catch let error as SupabaseError {
            throw AppError.supabaseError(error)
        } catch let error as MappingError {
            throw AppError.mappingError(error)
        }
    }
}

extension UserInfoRepositoryImpl {
    private func convertToUser(from dto: UserDTO) throws -> User {
        guard let name = dto.name,
              let nickname = dto.nickname,
              let gender = dto.gender,
              let birth = dto.birth,
              let profileImageCode = dto.profileImageCode,
              let authProvider = dto.authProvider
        else {
            throw MappingError.userDTOToUser
        }
        return User(
            name: name,
            email: dto.email,
            nickname: nickname,
            gender: gender,
            birth: birth,
            profileImageCode: profileImageCode,
            authProvider: authProvider
        )
    }
}
