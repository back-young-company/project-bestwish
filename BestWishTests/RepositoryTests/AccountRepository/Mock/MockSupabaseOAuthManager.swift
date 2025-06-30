//
//  MockSupabaseOAuthManager.swift
//  BestWishTests
//
//  Created by 이수현 on 6/26/25.
//

import Foundation
@testable import BestWish

import Supabase

/// Mock SupabaseOAuthManager
final class MockSupabaseOAuthManager: SupabaseOAuthManager {
    var shouldThrow = false

    func checkSupabaseSession(_ keychain: any BestWish.KeyChainManager) async -> Bool {
        true
    }
    
    func checkSignInState() async throws -> Bool {
        if shouldThrow {
            throw AuthError.appleDidCompleteFailed
        }
        return true
    }
    
    func logIn(type: BestWish.SocialType, _ keyChain: any BestWish.KeyChainManager) async throws {
        if shouldThrow {
            throw AuthError.appleDidCompleteFailed
        }
        return
    }
    
    func logOut(_ keyChain: any BestWish.KeyChainManager) async throws {
        if shouldThrow {
            throw AuthError.appleDidCompleteFailed
        }
        return
    }
    
    func withdraw(_ keyChain: any BestWish.KeyChainManager) async throws {
        if shouldThrow {
            throw AuthError.appleDidCompleteFailed
        }
        return
    }
    
    func logInApple() async throws -> (authorizationCode: String, session: Supabase.Session) {
        throw AuthError.appleDidCompleteFailed
    }
    
    func requestClientSecret(_ keyChain: any BestWish.KeyChainManager) async throws -> String {
        if shouldThrow {
            throw AuthError.appleDidCompleteFailed
        }
        return ""
    }
    
    func revokeAccount(_ token: String, _ clientSecret: String) async throws {
        if shouldThrow {
            throw AuthError.appleDidCompleteFailed
        }
        return
    }
    
    func requestAppleAccessToken(code: String, clientSecret: String) async throws -> Data {
        if shouldThrow {
            throw AuthError.appleDidCompleteFailed
        }
        return Data()
    }
    
    func parsingAccessToken(data: Data) throws -> String {
        if shouldThrow {
            throw AuthError.appleDidCompleteFailed
        }
        return ""
    }
    
    func logInKakao() async throws -> Supabase.Session? {
        if shouldThrow {
            throw AuthError.appleDidCompleteFailed
        }
        return nil
    }
    
    func unlinkKakaoAccount(_ token: String) async throws {
        if shouldThrow {
            throw AuthError.appleDidCompleteFailed
        }
        return
    }
}
