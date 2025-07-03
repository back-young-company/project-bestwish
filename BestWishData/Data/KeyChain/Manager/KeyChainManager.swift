//
//  KeyChainManager.swift
//  BestWish
//
//  Created by 이수현 on 6/26/25.
//

import Foundation

public import Supabase

/// 키체인 매니저 프로토콜
public protocol KeyChainManager {
    ///  모든 토큰 저장
    func saveAllToken(session: Supabase.Session) async

    ///  모든 토큰 삭제
    func deleteAllToken() async

    /// 토큰  읽기
    nonisolated func read(token: Token) -> String?
}
