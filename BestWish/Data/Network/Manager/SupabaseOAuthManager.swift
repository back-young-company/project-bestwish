//
//  SupabaseOAuthManager.swift
//  BestWish
//
//  Created by yimkeul on 6/7/25.
//

import AuthenticationServices
import Foundation

import Supabase

final class SupabaseOAuthManager: NSObject {

    // actor KeyChainManager 인스턴스
    public var continuation: CheckedContinuation<(String, Supabase.Session), Error>?
    public weak var presentationWindow: UIWindow?
    public var kakaoAuthSession: ASWebAuthenticationSession?
    public var currentNonce: String?

    let client = SupabaseClient(
        supabaseURL: Bundle.main.supabaseURL,
        supabaseKey: Bundle.main.apiKey
    )

    /// Supabase 토근 확인 및 세션 연결
    func checkLoginState(_ keychain: KeyChainManager) async -> Bool {
        // nonisolated read 이므로 await 없이 즉시 반환
        guard
            let accessToken = keychain.read(token: .init(service: .access)),
            let refreshToken = keychain.read(token: .init(service: .refresh))
            else {
            NSLog("KeyChain 읽어오기 실패")
            return false
        }

        let session: Supabase.Session

        do {
            session = try await client.auth.setSession(
                accessToken: accessToken,
                refreshToken: refreshToken
            )

            Task.detached(priority: .utility) {
                await keychain.saveAllToken(session: session)
                NSLog("토큰 로그인 세션 유지 성공")
            }
            return true
        } catch {
            Task.detached(priority: .utility) {
                NSLog("토큰 로그인 세션 복원 실패:", error.localizedDescription)
                await keychain.deleteAllToken()
            }
            return false
        }

    }

    /// 온보딩 필요 유무 확인
    /// Supabase에서 UserInfo 테이블의 role 값 확인 (USER : GUEST = true : false)
    func checkOnboardingState() async -> Bool {
        struct Role: Codable { let role: String }
        do {
            let roles: [Role] = try await client
                .from("UserInfo")
                .select("role")
                .execute()
                .value // [Role]

            let role = roles.map(\.role).first

            NSLog("roles: \(roles.map(\.role))") // ["USER"]
            return role == "USER"
        } catch {
            NSLog("Supabase Request User Role Failed")
            return false
        }

    }

    /// 로그인
    func signIn(type: SocialType, _ keychain: KeyChainManager) async throws {
        guard let session = try await oauthSessionSignIn(type: type) else { return }
        await keychain.saveAllToken(session: session)

        // FIXME: - 화면이동을 다른곳에서 하기
        let isNeedOnboarding = await checkOnboardingState()
        if isNeedOnboarding {
            SampleViewChangeManager.shared.goMainView()
        } else {
            SampleViewChangeManager.shared.goOnboardingView()
        }

    }

    /// 로그아웃
    func signOut(_ keychain: KeyChainManager) async throws {
        do {
            try await client.auth.signOut()
            // 로그아웃 후 키체인 삭제
            Task.detached(priority: .utility) {
                await keychain.deleteAllToken()
            }
            // FIXME: - 화면이동을 다른곳에서 하기
            SampleViewChangeManager.shared.goLoginView()
        } catch {
            throw AuthError.signOutFailed(error)
        }
    }

    /// 회원 탈퇴
    func withdraw(_ keyChain: KeyChainManager) async throws {
        let session = try await client.auth.session
        guard
            let rawProvider = session.user.appMetadata["provider"]?.rawValue,
            let socialProvider = Provider(rawValue: rawProvider)
            else {
            throw AuthError.missProvider
        }

        switch socialProvider {
        case .kakao:
            guard let session = try await signInKakao(),
                let providerToken = session.providerToken
                else { return }
            NSLog("Success - 1: \(session)")
            try await unlinkKakaoAccount(providerToken)
            NSLog("Success - 2: withdraw")
            try await client.rpc("delete_current_user").execute()
            NSLog("Success - 3: delete supabase")
            try await signOut(keyChain)
            NSLog("Success - 4: signOut")

        case .apple:
            // 애플 AccessToken 요청
            let (code, _) = try await signInApple()
            NSLog("Success - 1: \(code)")
            let clientSecret = try await requestClientSecret(keyChain)
            NSLog("Success - 2: \(clientSecret)")
            let requestAppleAccessToken = try await requestAppleAccessToken(code: code, clientSecret: clientSecret)
            NSLog("Success - 3: \(requestAppleAccessToken)")
            let appleAccessToken = try parsingAccessToken(data: requestAppleAccessToken)
            NSLog("Success - 4: \(appleAccessToken)")

            // 애플 회원탈퇴 요청
            try await revokeAccount(appleAccessToken, clientSecret)
            NSLog("Success - 5: withdraw")
            try await client.rpc("delete_current_user").execute()
            NSLog("Success - 6: delete supabase")
            try await signOut(keyChain)
            NSLog("Success - 7: signOut")

        default:
            break
        }
    }

    /// 소셜 로그인 OAUTH 인증
    private func oauthSessionSignIn(type: SocialType) async throws -> Session? {
        switch type {
        case .apple:
            let (_, session) = try await signInApple()
            return session

        case .kakao:
            let session = try await signInKakao()
            return session
        }
    }

}


// MARK: - Login할때 하단으로 부터 웹뷰 제어
extension SupabaseOAuthManager: ASWebAuthenticationPresentationContextProviding, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return presentationWindow ?? UIWindow()
    }
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return presentationWindow ?? UIWindow()
    }
}
