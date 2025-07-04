//
//  KeyChainManager.swift
//  BestWish
//
//  Created by 이수현 on 6/26/25.
//

import Foundation

/// 키체인 매니저 프로토콜
public protocol KeyChainManager {

    /// 토큰 저장
    func save(token: Token) async

    ///  모든 토큰 삭제
    func deleteAllToken() async

    /// 토큰  읽기
    nonisolated func read(token: Token) -> String?
}
