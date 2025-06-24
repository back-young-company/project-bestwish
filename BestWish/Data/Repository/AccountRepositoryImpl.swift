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
    private let keyChain: KeyChainManager
    private let dummyCoordinator: DummyCoordinator

    init(
        manager: SupabaseOAuthManager,
        keyChain: KeyChainManager,
        dummyCoordinator: DummyCoordinator
    ) {
        self.manager = manager
        self.keyChain = keyChain
        self.dummyCoordinator = dummyCoordinator
    }

	/// 로그인 확인
    func checkTokenState() async -> Bool {
        await manager.checkTokenState(keyChain)
    }

	/// 온보딩 확인
    func checkOnboardingState() async -> Bool {
        await manager.checkOnboardingState()
    }

    /// 로그인
    func login(type: SocialType) async throws -> Bool {
        return try await manager.signIn(type: type, keyChain)
    }

    /// 로그아웃
    func logout() async throws -> Bool {
        return try await manager.signOut(keyChain)
    }

    /// 회원탈퇴
    func withdraw() async throws -> Bool {
        try await manager.withdraw(keyChain)
    }

}
