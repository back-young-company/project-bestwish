//
//  AccountRepositoryImpl.swift
//  BestWish
//
//  Created by 이수현 on 6/17/25.
//

import Foundation

/// 유저 계정 관련 레포지토리
final class AccountRepositoryImpl: AccountRepository {
    private let manager: SupabaseOAuthManager

    init(manager: SupabaseOAuthManager) {
        self.manager = manager
    }

    /// 로그인
    func login(type: SocialType) async throws {
        try await manager.signIn(type: type)
    }

    /// 로그아웃
    func logout() async throws {
        try await manager.signOut()
    }

    /// 회원탈퇴
    func withdraw() async throws {
        try await manager.withdraw()
    }
}
