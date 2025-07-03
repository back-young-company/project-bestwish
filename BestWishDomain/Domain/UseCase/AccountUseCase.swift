//
//  AccountUseCase.swift
//  BestWish
//
//  Created by 이수현 on 6/17/25.
//

import Foundation

/// 계정 정보 관련 UseCase 프로토콜
public protocol AccountUseCase {
    /// 회원가입 유뮤
    func checkSignInState() async throws -> Bool
    
    /// 로그인
    func login(type: SocialType) async throws

    /// 로그아웃
    func logout() async throws

    /// 회원탈퇴
    func withdraw() async throws
}

/// 계정 정보 관련 UseCase
public final class AccountUseCaseImpl: AccountUseCase {
    private let repository: AccountRepository

    public init(repository: AccountRepository) {
        self.repository = repository
    }

    /// 회원가입 유뮤
    public func checkSignInState() async throws -> Bool {
        try await repository.checkSignInState()
    }
    
    /// 로그인
    public func login(type: SocialType) async throws {
        try await repository.login(type: type)
    }

    /// 로그아웃
    public func logout() async throws {
        try await repository.logout()
    }

    /// 회원탈퇴
    public func withdraw() async throws {
        try await repository.withdraw()
    }
}
