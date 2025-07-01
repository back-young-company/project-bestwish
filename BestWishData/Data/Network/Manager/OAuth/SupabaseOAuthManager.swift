//
//  SupabaseOAuthManager.swift
//  BestWish
//
//  Created by 이수현 on 6/26/25.
//

import BestWishDomain
import Foundation

public import Supabase

/// OAuthManager 프로토콜
public protocol SupabaseOAuthManager {
    /// Supabase 토근 확인 및 세션 연결
    func checkSupabaseSession(_ keychain: KeyChainManager) async -> Bool

    /// 회원가입 필요 유무 확인
    /// Supabase에서 UserInfo 테이블의 role 값 확인 (USER : GUEST = true : false)
    func checkSignInState() async throws -> Bool

    /// 로그인
    func logIn(type: SocialType, _ keyChain: KeyChainManager) async throws

    /// 로그아웃
    func logOut(_ keyChain: KeyChainManager) async throws

    /// 회원 탈퇴
    func withdraw(_ keyChain: KeyChainManager) async throws

    // MARK: - SupabaseOAuth를 활용한 애플 로그인
    /// 애플 로그인 시도
    func logInApple() async throws -> (authorizationCode: String, session: Supabase.Session)

    /// Supabase에 Client_Secret 값 요청
    func requestClientSecret(_ keyChain: KeyChainManager) async throws -> String

    /// 애플 회원탈퇴
    func revokeAccount(_ token: String, _ clientSecret: String) async throws

    /// 애플 RestAPI로 AccessToken 요청
    func requestAppleAccessToken(code: String, clientSecret: String) async throws -> Data

    /// Data 타입의 AccessToken String으로 파싱
    func parsingAccessToken(data: Data) throws -> String


    // MARK: - SupabaseOAuth를 활용한 카카오 로그인
    /// 카카오 로그인
    func logInKakao() async throws -> Supabase.Session?

    /// 카카오 회원탈퇴
    func unlinkKakaoAccount(_ token: String) async throws
}
