//
//  AppleLogin.swift
//  BestWish
//
//  Created by yimkeul on 6/9/25.
//

import Foundation
import Supabase
import AuthenticationServices
import Alamofire

extension SupabaseOAuthManager {

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

    func getAppleAccessToken() async throws -> String {
        let (code, _) = try await signInApple()
        let clientSecret = try await requestSecret()
        let url = "https://appleid.apple.com/auth/token"
        let clientID = Bundle.main.clientID
        let parameters: [String: String] = [
            "grant_type": "authorization_code",
            "code": code,
            "client_id": clientID,
            "client_secret": clientSecret
        ]

        let data = try await AF.request(
            url,
            method: .post,
            parameters: parameters,
            encoder: URLEncodedFormParameterEncoder.default,
            headers: ["Content-Type": "application/x-www-form-urlencoded"]
        )
        .validate()
        .serializingData()
        .value

        let jsonAny = try JSONSerialization.jsonObject(with: data, options: [])
        guard
            let json = jsonAny as? [String: Any],
            let accessToken = json["access_token"] as? String
        else {
            throw NSError(
                domain: "AppleLogin",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "access_token을 찾을 수 없습니다"]
            )
        }

        return accessToken
    }

    private func requestSecret() async throws -> String {
        // nonisolated read 메서드를 통해 동기적으로 즉시 읽기
        guard let token = keychain.read(token: .init(service: .access)) else {
            throw NSError(
                domain: "AppleLogin",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "키체인에서 액세스 토큰을 찾을 수 없습니다"]
            )
        }

        let endPoint = "swift-api/generate-client-secret"
        struct SecretResponse: Codable {
            let client_secret: String
        }

        let response: SecretResponse = try await client.functions.invoke(
            endPoint,
            options: .init(
                method: .get,
                headers: ["Authorization": "Bearer \(token)"]
            )
        )
        return response.client_secret
    }

    func revokeAccount(_ token: String) async throws {
        let url = "https://appleid.apple.com/auth/revoke"
        let clientID = Bundle.main.clientID
        let clientSecret: String

        do {
            clientSecret = try await requestSecret()
        } catch {
            print("Client Secret 획득 실패:", error.localizedDescription)
            return
        }

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
                    print("리프레시 토큰 리보크 성공. 상태 코드:", response.response?.statusCode ?? -1)
                    continuation.resume()
                case .failure(let error):
                    print("리프레시 토큰 리보크 실패. HTTP \(response.response?.statusCode ?? -1) 오류: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

extension SupabaseOAuthManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard
            let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let fullName = appleIDCredential.fullName,
            let authorizationCode = appleIDCredential.authorizationCode,
            let authCodeString = String(data: authorizationCode, encoding: .utf8),
            let idTokenData = appleIDCredential.identityToken,
            let idTokenString = String(data: idTokenData, encoding: .utf8),
            let nonce = currentNonce
        else {
            continuation?.resume(throwing: NSError(domain: "", code: -1, userInfo: nil))
            continuation = nil
            print("Apple ID Credential에서 identityToken 또는 nonce를 가져올 수 없음")
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
                if name != "" {
                    try await client.auth.update(user: .init(data: ["full_name": .string(name)]))
                    print("auth.users 이름 갱신 성공")

                    try await client
                        .from("UserInfo")
                        .update(["name": name])
                        .eq("id", value: session.user.id)
                        .execute()
                    print("public.user 이름 갱신 성공")
                    print("애플 로그인 성공")
                }
                continuation?.resume(returning: (authCodeString, session))
            } catch {
                print("Supabase 로그인 오류:", error.localizedDescription)
                continuation?.resume(throwing: error)
            }
            continuation = nil
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        continuation?.resume(throwing: error)
        print("Apple 인증 실패", error.localizedDescription)
        continuation = nil
    }
}

