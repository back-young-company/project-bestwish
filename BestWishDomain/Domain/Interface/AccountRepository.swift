//
//  AccountRepository.swift
//  BestWish
//
//  Created by 이수현 on 6/17/25.
//

import Foundation

/// 계정 관련 레포지토리 프로토콜
public protocol AccountRepository {

    /// Supabase 세션 연결 확인
    func checkSupabaseSession() async -> Bool

	/// 회원가입 확인
    func checkSignInState() async throws -> Bool

	/// 로그인
    func login(type: SocialType) async throws

	/// 로그아웃
    func logout() async throws

    /// 회원탈퇴
    func withdraw() async throws
}
