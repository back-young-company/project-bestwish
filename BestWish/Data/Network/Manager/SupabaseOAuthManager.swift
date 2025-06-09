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

    private override init() {
        super.init()
    }
    public var continuation: CheckedContinuation<(String, Supabase.Session), Error>?
    public weak var presentationWindow: UIWindow?
    public var currentNonce: String?

    let client = SupabaseClient (
        supabaseURL: URL(string: "https://\(Bundle.main.supabaseURL)")!,
        supabaseKey: Bundle.main.apiKey
    )

    func restoreSessionIfNeeded() async -> Bool {
        // 1) Keychain에서 꺼내기
        guard
            let accessToken = KeyChainManager.shared.read(token: Token(service: .access)),
            let refreshToken = KeyChainManager.shared.read(token: Token(service: .refresh))
            else {
            return false
        }

        // 2) Supabase SDK로 세션 복원(비동기)
        do {
            let session = try await client.auth.setSession(
                accessToken: accessToken,
                refreshToken: refreshToken
            )
            KeyChainManager.shared.saveAllToken(session: session)
            print("토큰 로그인 세션 유지 성공")
            return true
        } catch {
            print("토큰 로그인 세션 복원 실패:", error.localizedDescription)
            // 복원 실패 시 Keychain 정리
            KeyChainManager.shared.deleteAllToken()
            return false
        }
    }

    func signIn(type: SocialType) {
        Task {
            switch type {
            case .apple:
                do {
                    let(_, session) = try await signInApple()
                    KeyChainManager.shared.saveAllToken(session: session)
                } catch {
                    print("\(error.localizedDescription)")
                }
            case .kakao:
                do {
                    guard let session = try await signInKakao() else {
                        return
                    }
                    KeyChainManager.shared.saveAllToken(session: session)
                } catch {
                    print("\(error.localizedDescription)")
                }
            }
        }
        gotoOnboardingView()
    }

    func signOut() async throws {
        do {
            try await client.auth.signOut()
            print("로그아웃 요청 보냄")
        } catch {
            print("Supabase signOut 실패:", error.localizedDescription)
        }
        print("로그아웃")
        gotoLoginView()
    }

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
                let providerToken = session.providerToken else {
                return
            }

            do {
                try await unlinkKakaoAccount(providerToken)
            } catch {
                print("카카오 계정삭제 실패", error.localizedDescription)
                return
            }

            do {
                _ = try await client
                    .rpc("delete_current_user")
                    .execute()
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
                _ = try await client
                    .rpc("delete_current_user")
                    .execute()
                try await signOut()
            } catch {
                print("supabase User 삭제 실패 :", error.localizedDescription)
            }
         default: break
        }

    }
}

extension SupabaseOAuthManager {
    enum SocialType {
        case kakao
        case apple
    }
}


// 화면이동
// TODO:  Coordinator로 변경할것
extension SupabaseOAuthManager {
    func gotoOnboardingView() {
        DispatchQueue.main.async {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let delegate = scene.delegate as? SceneDelegate {
                delegate.showOnboardingView()
            }
        }
    }

    private func gotoLoginView() {
        DispatchQueue.main.async {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let delegate = scene.delegate as? SceneDelegate {
                delegate.showLoginView()
            }
        }
    }
}
