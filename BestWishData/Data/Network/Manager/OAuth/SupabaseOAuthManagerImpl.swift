//
//  SupabaseOAuthManager.swift
//  BestWish
//
//  Created by yimkeul on 6/7/25.
//

import AuthenticationServices
import BestWishDomain
import Foundation

internal import Supabase

/// OAuthManager 구현부
public final class SupabaseOAuthManagerImpl: NSObject, SupabaseOAuthManager {

    var continuation: CheckedContinuation<(String, Supabase.Session), Error>?
    var kakaoAuthSession: ASWebAuthenticationSession?
    var currentNonce: String?

    let client = SupabaseClient(
        supabaseURL: Bundle.main.supabaseURL,
        supabaseKey: Bundle.main.apiKey
    )

    public override init() {
        super.init()
    }

    /// Supabase 토근 확인 및 세션 연결
    public func checkSupabaseSession(_ keychain: KeyChainManager) async -> Bool {
        let (accessToken, refreshToken) = chechTokens(keychain)

        let session: Supabase.Session

        do {
            session = try await client.auth.setSession(
                accessToken: accessToken,
                refreshToken: refreshToken
            )

            Task.detached(priority: .utility) {
                async let saveAccessToken:() =  keychain.save(token: Token(service: .access, value: session.accessToken))
                async let saveRefreshToken:() =  keychain.save(token: Token(service: .refresh, value: session.refreshToken))
                _ = await (saveAccessToken,saveRefreshToken)
                NSLog("로그인 세션 유지 성공")
            }
            return true
        } catch {
            Task.detached(priority: .utility) {
                await keychain.deleteAllToken()
                NSLog("로그인 세션 복원 실패: \(AuthError.supabaseSetSessionFailed(error).debugDescription)")
            }
            return false
        }

    }

    /// 회원가입 필요 유무 확인
    /// Supabase에서 UserInfo 테이블의 role 값 확인 (USER : GUEST = true : false)
    public func checkSignInState() async throws -> Bool {
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
            NSLog(AuthError.supabaseRequestRoleFailed(error).debugDescription)
            throw AuthError.supabaseRequestRoleFailed(error)
        }

    }

    /// 로그인
    public func logIn(type: SocialType, _ keyChain: KeyChainManager) async throws {
        let session = try await oauthSessionLogIn(type: type)

        if let session = session {
            Task.detached(priority: .utility) {
                async let saveAccessToken:() =  keyChain.save(token: Token(service: .access, value: session.accessToken))
                async let saveRefreshToken:() =  keyChain.save(token: Token(service: .refresh, value: session.refreshToken))
                _ = await (saveAccessToken,saveRefreshToken)
            }
        }
    }

    /// 로그아웃
    public func logOut(_ keyChain: KeyChainManager) async throws {
        do {
            try await client.auth.signOut()
            // 로그아웃 후 키체인 삭제
            Task.detached(priority: .utility) {
                await keyChain.deleteAllToken()
            }
            NSLog("Success : signOut")
        } catch {
            throw AuthError.logOutFailed(error)
        }
    }

    /// 회원 탈퇴
    public func withdraw(_ keyChain: KeyChainManager) async throws {
        let session = try await client.auth.session
        guard
            let rawProvider = session.user.appMetadata["provider"]?.rawValue,
            let socialProvider = Provider(rawValue: rawProvider)
            else {
            throw AuthError.missProvider
        }

        switch socialProvider {
        case .kakao:
            guard let session = try await logInKakao(),
                let providerToken = session.providerToken else {
                return
            }
            NSLog("Success - 1: \(session)")
            try await unlinkKakaoAccount(providerToken)
            NSLog("Success - 2: withdraw")
        case .apple:
            async let loginResult = logInApple()
            async let clientSecretResult = requestClientSecret(keyChain)

            let (code, _) = try await loginResult
            NSLog("Success - 1: \(code)")
            let clientSecret = try await clientSecretResult
            NSLog("Success - 2: \(clientSecret)")
            // 애플 AccessToken 요청
            let requestAppleAccessToken = try await requestAppleAccessToken(code: code, clientSecret: clientSecret)
            NSLog("Success - 3: \(requestAppleAccessToken)")
            let appleAccessToken = try parsingAccessToken(data: requestAppleAccessToken)
            NSLog("Success - 4: \(appleAccessToken)")

            // 애플 회원탈퇴 요청
            try await revokeAccount(appleAccessToken, clientSecret)
            NSLog("Success - 5: withdraw")
        default:
            break
        }
        async let rpc = client.rpc("delete_current_user").execute()
        async let deleteKeychain: () = keyChain.deleteAllToken()

        do {
            _ = try await rpc
            NSLog("Success - : delete supabase")
            await deleteKeychain
            NSLog("Success - : 토큰 삭제 ")
        } catch {
            throw AuthError.supabaseRPCFailed(error)
        }
    }

    /// 키체인에 저장된 supabase token 정보 가져오기
    private func chechTokens(_ keyChain: KeyChainManager) -> (String, String) {
        // nonisolated read 이므로 await 없이 즉시 반환
        guard
            let accessToken = keyChain.read(token: .init(service: .access)),
            let refreshToken = keyChain.read(token: .init(service: .refresh))
            else {
            NSLog(KeyChainError.readError.debugDescription)
            return ("","")
        }
        return (accessToken, refreshToken)
    }

    /// 소셜 로그인 OAUTH 인증
    private func oauthSessionLogIn(type: SocialType) async throws -> Session? {
        switch type {
        case .apple:
            let (_, session) = try await logInApple()
            return session

        case .kakao:
            let session = try await logInKakao()
            return session
        }
    }

}


// MARK: - Login할때 하단으로 부터 웹뷰 제어
extension SupabaseOAuthManagerImpl: ASWebAuthenticationPresentationContextProviding, ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return  UIWindow()
    }
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return  UIWindow()
    }
}
