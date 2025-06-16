//
//  UserInfoUseCase.swift
//  BestWish
//
//  Created by 이수현 on 6/16/25.
//

import Foundation

protocol UserInfoUseCase {
    func getUserInfo() async throws -> User
    func updateUserInfo(
        profileImageCode: Int?,
        nickname: String?,
        gender: Int?,
        birth: Date?
    ) async throws
}

extension UserInfoUseCase {
    func updateUserInfo(
        profileImageCode: Int? = nil,
        nickname: String? = nil,
        gender: Int? = nil,
        birth: Date? = nil
    ) async throws {
        try await updateUserInfo(
            profileImageCode: profileImageCode,
            nickname: nickname,
            gender: gender,
            birth: birth
        )
    }
}

final class UserInfoUseCaseImpl: UserInfoUseCase {
    private let repository: UserInfoRepository

    init(repository: UserInfoRepository) {
        self.repository = repository
    }

    func getUserInfo() async throws -> User {
        try await repository.getUserInfo()
    }

    func updateUserInfo(
        profileImageCode: Int?,
        nickname: String?,
        gender: Int?,
        birth: Date?
    ) async throws {
        try await repository.updateUserInfo(
            profileImageCode: profileImageCode,
            nickname: nickname,
            gender: gender,
            birth: birth
        )
    }
}
