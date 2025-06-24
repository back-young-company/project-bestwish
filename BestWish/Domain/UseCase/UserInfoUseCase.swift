//
//  UserInfoUseCase.swift
//  BestWish
//
//  Created by 이수현 on 6/16/25.
//

import Foundation

/// 유저 정보 관련 UseCase 프로토콜
protocol UserInfoUseCase {
    /// 유저 정보 불러오기
    func getUserInfo() async throws -> User

    /// 유저 정보 업데이트
    func updateUserInfo(
        profileImageCode: Int?,
        nickname: String?,
        gender: Int?,
        birth: Date?
    ) async throws

    /// 닉네임 유효성 검사
    func isValidNickname(_ nickname: String) -> Bool
}

// MARK: - Protocol 메서드의 파라미터 초기값 설정
extension UserInfoUseCase {
    /// 유저 정보 업데이트
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

/// 유저 정보 관련 UseCase 
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

    func isValidNickname(_ nickname: String) -> Bool {
        let nicknameRegex =  "^[가-힣A-Za-z0-9]{2,10}$"
        let isValid = NSPredicate(format: "SELF MATCHES %@", nicknameRegex)
            .evaluate(with: nickname)
        return isValid
    }
}
