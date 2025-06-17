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

    func isValidNickname(_ nickname: String) -> Bool
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

    /// 닉네임 유효성 검사
    func isValidNickname(_ nickname: String) -> Bool {
        let nicknameRegex =  "^[가-힣A-Za-z0-9]{2,10}$"
        let isValid = NSPredicate(format: "SELF MATCHES %@", nicknameRegex)
            .evaluate(with: nickname)
        return isValid
    }
}
