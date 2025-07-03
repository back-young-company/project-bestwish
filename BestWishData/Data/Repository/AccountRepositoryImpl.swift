//
//  AccountRepositoryImpl.swift
//  BestWish
//
//  Created by 이수현 on 6/17/25.
//

import BestWishDomain
import Foundation

/// 유저 계정 관련 레포지토리
public final class AccountRepositoryImpl: AccountRepository {
    private let manager: SupabaseOAuthManager
    private let keyChain: KeyChainManager

    public init(
        manager: SupabaseOAuthManager,
        keyChain: KeyChainManager
    ) {
        self.manager = manager
        self.keyChain = keyChain
    }

    /// Supabase 세션 연결 확인
    public func checkSupabaseSession() async -> Bool {
        await manager.checkSupabaseSession(keyChain)
    }

	/// 회원가입 확인
    public func checkSignInState() async throws -> Bool {
        do {
            return try await manager.checkSignInState()
        } catch let error as AuthError {
            throw AppError.authError(error)
        }
    }

    /// 로그인
    public func login(type: SocialType) async throws {
        do {
            try await manager.logIn(type: type, keyChain)
        } catch let error as AuthError {
            throw AppError.authError(error)
        }
    }

    /// 로그아웃
    public func logout() async throws {
        do {
            try await manager.logOut(keyChain)
        } catch let error as AuthError {
            throw AppError.authError(error)
        }
    }

    /// 회원탈퇴
    public func withdraw() async throws {
        do {
            try await manager.withdraw(keyChain)
        } catch let error as AuthError {
            throw AppError.authError(error)
        }
    }
}
