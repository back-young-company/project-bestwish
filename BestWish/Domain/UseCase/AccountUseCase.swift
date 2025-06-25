//
//  AccountUseCase.swift
//  BestWish
//
//  Created by 이수현 on 6/17/25.
//

import Foundation

/// 계정 정보 관련 UseCase 프로토콜
protocol AccountUseCase {
    /// 온보딩 유뮤
    func checkOnboardingState() async throws -> Bool
    
    /// 로그인
    func login(type: SocialType) async throws

    /// 로그아웃
    func logout() async throws

    /// 회원탈퇴
    func withdraw() async throws
}

/// 계정 정보 관련 UseCase
final class AccountUseCaseImpl: AccountUseCase {
    private let repository: AccountRepository

    init(repository: AccountRepository) {
        self.repository = repository
    }

    /// 온보딩 유뮤
    func checkOnboardingState() async throws -> Bool {
        try await repository.checkOnboardingState()
    }

    /// 로그인
    func login(type: SocialType) async throws {
        try await repository.login(type: type)
    }

    /// 로그아웃
    func logout() async throws {
        try await repository.logout()
    }

    /// 회원탈퇴
    func withdraw() async throws {
        try await repository.withdraw()
    }
}
