//
//  AppleLogin.swift
//  BestWish
//
//  Created by yimkeul on 6/9/25.
//

import AuthenticationServices
import CryptoKit
import Foundation

import Alamofire
import Supabase

// MARK: - SupabaseOAuth를 활용한 애플 로그인
extension SupabaseOAuthManagerImpl {

    /// 애플 로그인 시도
    func signInApple() async throws -> (authorizationCode: String, session: Supabase.Session) {
        let nonce = generateRandomNonce()
        currentNonce = nonce
        let nonceHash = sha256(nonce)

        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = nonceHash

        let authController = ASAuthorizationController(authorizationRequests: [request])
        authController.delegate = self
        authController.presentationContextProvider = self

        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<(String, Supabase.Session), Error>) in
            self.continuation = continuation
            authController.performRequests()
        }
    }

    /// Supabase에 Client_Secret 값 요청
    func requestClientSecret(_ keyChain: KeyChainManager) async throws -> String {
        guard let token = keyChain.read(token: .init(service: .access)) else {
            NSLog("ERROR : Supabase AccessToken Read Fail")
            // FIXME: - 현재 아래 error는 Alert으로 안나오는 현상이 있음.
            throw KeyChainError.readError
        }

        do {
            let endPoint = "swift-api/generate-client-secret"
            let response: [String: String] = try await client.functions.invoke(
                endPoint,
                options: .init(
                    method: .get,
                    headers: ["Authorization": "Bearer \(token)"]
                )
            )

            guard let clientSecret = response["client_secret"] else {
                throw AuthError.supabaseRequestSecretCodeNil
            }

            return clientSecret
        }
        catch {
            NSLog("ERROR : requestClientSecret")
            throw AuthError.supabaseRequestSecretCodeFailed(error)
        }
    }

    /// 애플 회원탈퇴
    func revokeAccount(_ token: String, _ clientSecret: String) async throws {
        let url = "https://appleid.apple.com/auth/revoke"
        let clientID = Bundle.main.clientID

        try await withCheckedThrowingContinuation { continuation in
            let params: [String: String] = [
                "client_id": clientID,
                "client_secret": clientSecret,
                "token": token,
                "token_type_hint": "access_token"
            ]

            AF.request(
                url,
                method: .post,
                parameters: params,
                encoder: URLEncodedFormParameterEncoder.default,
                headers: ["Content-Type": "application/x-www-form-urlencoded"]
            )
                .validate()
                .response { response in
                switch response.result {
                case .success:
                    NSLog("애플 회원탈퇴 성공. 상태 코드:", response.response?.statusCode ?? -1)
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: AuthError.withdrawFailed(error))
                }
            }
        }
    }

    /// 애플 RestAPI로 AccessToken 요청
    func requestAppleAccessToken(code: String, clientSecret: String) async throws -> Data {
        do {
            let url = "https://appleid.apple.com/auth/token"
            let clientID = Bundle.main.clientID
            let parameters: [String: String] = [
                "grant_type": "authorization_code",
                "code": code,
                "client_id": clientID,
                "client_secret": clientSecret
            ]

            return try await AF.request(
                url,
                method: .post,
                parameters: parameters,
                encoder: URLEncodedFormParameterEncoder.default,
                headers: ["Content-Type": "application/x-www-form-urlencoded"]
            )
                .validate()
                .serializingData()
                .value
        } catch {
            NSLog("ERROR : requestAppleAccessToken : \(error.localizedDescription) \(code) : \(clientSecret)")
            throw AuthError.appleRequestAccessTokenFailed(error)
        }
    }

    /// Data 타입의 AccessToken String으로 파싱
    func parsingAccessToken(data: Data) throws -> String {
        let jsonAny = try JSONSerialization.jsonObject(with: data, options: [])

        guard
            let json = jsonAny as? [String: Any],
            let accessToken = json["access_token"] as? String
            else {
            NSLog("Error: parsingAccessToken")
            throw AuthError.encodeParsingTokenError("access_token")
        }

        return accessToken
    }


    /// 애플 로그인용 nonce 생성
    private func generateRandomNonce(length: Int = 32) -> String {
        let characters = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                _ = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                return random
            }
            randoms.forEach { random in
                if remainingLength == 0 { return }
                if random < characters.count {
                    result.append(characters[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }

    /// 애플 로그인용 nonce 암호화
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}

// MARK: - 애플 로그인(Face,지문 인식) 완료 후 동작
extension SupabaseOAuthManagerImpl: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard
            let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let fullName = appleIDCredential.fullName,
            let authorizationCode = appleIDCredential.authorizationCode,
            let authCodeString = String(data: authorizationCode, encoding: .utf8),
            let idTokenData = appleIDCredential.identityToken,
            let idTokenString = String(data: idTokenData, encoding: .utf8),
            let nonce = currentNonce,
            let continuation
            else {
            continuation?.resume(throwing: AuthError.appleDidCompleteFailed)
            continuation = nil
            return
        }

        let formatter = PersonNameComponentsFormatter()
        formatter.style = .default
        let name = formatter.string(from: fullName)

        Task {
            do {
                let session = try await client.auth.signInWithIdToken(
                    credentials: .init(
                        provider: .apple,
                        idToken: idTokenString,
                        nonce: nonce
                    )
                )
                if !name.isEmpty {
                    try await client.auth.update(user: .init(data: ["full_name": .string(name)]))
                    NSLog("auth.users 이름 갱신 성공")

                    try await client
                        .from("UserInfo")
                        .update(["name": name])
                        .eq("id", value: session.user.id)
                        .execute()
                    NSLog("public.user 이름 갱신 성공")
                    NSLog("애플 로그인 성공")
                }
                continuation.resume(returning: (authCodeString, session))
            } catch {
                NSLog("Supabase 로그인 오류:", error.localizedDescription)
                continuation.resume(throwing: AuthError.signInFailed(.apple, error))
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        continuation?.resume(throwing: AuthError.appleDidCompleteFailed)
        continuation = nil
    }
}

