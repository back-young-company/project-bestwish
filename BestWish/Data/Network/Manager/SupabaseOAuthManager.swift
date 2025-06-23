//
//  SupabaseOAuthManager.swift
//  BestWish
//
//  Created by yimkeul on 6/7/25.
//

import Foundation
import Supabase
import AuthenticationServices

final class SupabaseOAuthManager: NSObject {

    static let shared = SupabaseOAuthManager()
    private override init() { super.init() }

    // actor KeyChainManager 인스턴스
    public let keychain = KeyChainManager()
    public var continuation: CheckedContinuation<(String, Supabase.Session), Error>?
    public weak var presentationWindow: UIWindow?
    public var kakaoAuthSession: ASWebAuthenticationSession?
    public var currentNonce: String?

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
            return false
        }

        do {
            let session = try await client.auth.setSession(
                accessToken: accessToken,
                refreshToken: refreshToken
            )

            // 백그라운드에서 저장/삭제 작업은 detached Task로
            Task.detached(priority: .utility) {
                await self.keychain.saveAllToken(session: session)
                print("토큰 로그인 세션 유지 성공")
            }
            return true
        } catch {
            Task.detached(priority: .utility) {
                print("토큰 로그인 세션 복원 실패:", error.localizedDescription)
                await self.keychain.deleteAllToken()
            }
            return false
        }
    }
    // MARK: Supabase에서 UserInfo 테이블의 role 값 확인 (USER : GUEST = true : false)
    private func isUser() async throws -> Bool {
        struct Role: Codable { let role: String }

        do {
            let roles: [Role] = try await client
                .from("UserInfo")
                .select("role")
                .execute()
                .value // [Role]

            guard let role = roles.map(\.role).first else {
                return false
            }

            print("roles:", roles.map(\.role)) // ["USER"]

            return role == "USER"
        } catch {
            throw SupabaseError.selectError(error)
        }
    }
    // MARK: - 온보딩 필요한지 확인
    /// singleton으로 sceneDelegate에서도 사용
    func isNeedOnboarding() async throws {
        let state = try await isUser()
        await MainActor.run {
            if state {
                SampleViewChangeManager.shared.goMainView()
            } else {
                SampleViewChangeManager.shared.goOnboardingView()
            }
        }
    }

    // MARK: 소셜 로그인 OAUTH 인증
    private func oauthSession(type: SocialType) async throws -> Session? {
        switch type {
        case .apple:
            let (_, session) = try await signInApple()
            return session

        case .kakao:
            let session = try await signInKakao()
            return session
        }
    }

    // MARK: – 로그인
    func signIn(type: SocialType) {
        Task {
            guard let session = try await oauthSession(type: type) else { return }
            await keychain.saveAllToken(session: session)
            try await isNeedOnboarding()
        }
    }

// MARK: – 로그아웃
    func signOut() async throws {
        do {
            try await client.auth.signOut()
            print("로그아웃 요청 보냄")
        } catch {
            print("Supabase signOut 실패:", error.localizedDescription)
        }

        // 로그아웃 후 키체인 삭제
        Task.detached(priority: .utility) {
            await self.keychain.deleteAllToken()
        }

        SampleViewChangeManager.shared.goLoginView()
    }

// MARK: – 회원 탈퇴
    func leaveService() async throws {
        let session = try await client.auth.session
        guard
            let rawProvider = session.user.appMetadata["provider"]?.rawValue,
            let socialProvider = Provider(rawValue: rawProvider)
            else {
            print("지원하지 않는 로그인 방식이거나 provider 정보가 없습니다.")
            return
        }

        switch socialProvider {
        case .kakao:
            guard let session = try await signInKakao(),
                let providerToken = session.providerToken
                else { return }

            do {
                try await unlinkKakaoAccount(providerToken)
            } catch {
                print("카카오 계정삭제 실패", error.localizedDescription)
                return
            }

            do {
                _ = try await client.rpc("delete_current_user").execute()
                try await signOut()
            } catch {
                print("supabase User 삭제 실패 :", error.localizedDescription)
            }

        case .apple:
            let token = try await getAppleAccessToken()

            do {
                try await revokeAccount(token)
            } catch {
                print("애플 계정삭제 실패", error.localizedDescription)
                return
            }

            do {
                _ = try await client.rpc("delete_current_user").execute()
                try await signOut()
            } catch {
                print("supabase User 삭제 실패 :", error.localizedDescription)
            }

        default:
            break
        }


    }
}

extension SupabaseOAuthManager {
    enum SocialType {
        case kakao
        case apple
    }
}

extension SupabaseOAuthManager: ASWebAuthenticationPresentationContextProviding, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return presentationWindow ?? UIWindow()
    }
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return presentationWindow ?? UIWindow()
    }
}
