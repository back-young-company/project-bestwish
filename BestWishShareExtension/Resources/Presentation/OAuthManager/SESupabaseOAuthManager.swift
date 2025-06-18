//
//  SESupabaseOAuthManager.swift
//  BestWishShareExtension
//
//  Created by 백래훈 on 6/18/25.
//

import Foundation

import Supabase

final class SESupabaseOAuthManager: NSObject {

    // actor KeyChainManager 인스턴스
    public let keychain = KeyChainManager()

    let client = SupabaseClient(
        supabaseURL: Bundle.main.supabaseURL,
        supabaseKey: Bundle.main.apiKey
    )

    // MARK: – Supabase 토근 확인 및 세션 연결
    func checkLoginState() async -> Bool {
        // nonisolated read 이므로 await 없이 즉시 반환
        guard
            let accessToken = keychain.read(token: .init(service: .access)),
            let refreshToken = keychain.read(token: .init(service: .refresh))
        else {
            print("토큰 가져오기 실패")
            return false
        }
        
        do {
            let session = try await client.auth.setSession(
                accessToken: accessToken,
                refreshToken: refreshToken
            )
            print("수파베이스 session: \(session)")
            
            // 백그라운드에서 저장/삭제 작업은 detached Task로
//            Task.detached(priority: .utility) {
//                await self.keychain.saveAllToken(session: session)
//                print("토큰 로그인 세션 유지 성공")
//            }
            return true
        } catch {
//            Task.detached(priority: .utility) {
//                print("토큰 로그인 세션 복원 실패:", error.localizedDescription)
//                await self.keychain.deleteAllToken()
//            }
            return false
        }
    }
}
