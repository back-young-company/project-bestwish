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
    private let keychain: KeyChainManager

    init(manager: SupabaseOAuthManager, keycahin: KeyChainManager) {
        self.manager = manager
        self.keychain = keycahin
    }

	/// 로그인 확인
    func checkLoginState() async -> Bool {
        await manager.checkLoginState(keychain)
    }

	/// 온보딩 확인
    func checkOnboardingState() async -> Bool {
        await manager.checkOnboardingState()
    }

    /// 로그인
    func login(type: SocialType) async throws {
        try await manager.signIn(type: type, keychain)
    }

    /// 로그아웃
    func logout() async throws {
        try await manager.signOut(keychain)
    }

    /// 회원탈퇴
    func withdraw() async throws {
        try await manager.withdraw(keychain)
    }
}
