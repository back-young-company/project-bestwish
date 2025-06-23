//
//  KakaoLogin.swift
//  BestWish
//
//  Created by yimkeul on 6/9/25.
//

import Foundation
import Supabase
import Alamofire

extension SupabaseOAuthManager {
    func signInKakao() async throws -> Supabase.Session? {
        guard let redirectURL = Bundle.main.redirectURL else {
            print("URL Scheme 못가져옴")
            return nil
        }
        do {
            let session = try await client.auth.signInWithOAuth(provider: Provider.kakao, redirectTo: redirectURL) { [weak self] session in
                guard let self else { return }

                self.kakaoAuthSession = session
                session.presentationContextProvider = self
                session.prefersEphemeralWebBrowserSession = true
            }
            kakaoAuthSession = nil
            return session
        } catch {
            kakaoAuthSession?.cancel()
            kakaoAuthSession = nil
            print("error: \(error.localizedDescription)")
            return nil
        }
    }

    func unlinkKakaoAccount(_ token: String) async throws {
        try await withCheckedThrowingContinuation { continuation in
            let url = "https://kapi.kakao.com/v1/user/unlink"
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token)"
            ]

            AF.request(url, method: .post, headers: headers)
                .validate()
                .responseData { response in
                switch response.result {
                case .success:
                    print("리프레시 토큰 리보크 성공. 상태 코드:", response.response?.statusCode ?? -1)
                    let bodyString = response.data.flatMap { String(data: $0, encoding: .utf8) } ?? "응답 바디 없음"
                    print(bodyString)
                    continuation.resume() // 성공
                case .failure(let error):
                    let statusCode = response.response?.statusCode ?? -1
                    let bodyString = response.data.flatMap { String(data: $0, encoding: .utf8) } ?? "응답 바디 없음"
                    print("리프레시 토큰 리보크 실패. HTTP \(statusCode), 응답: \(bodyString), 오류: \(error.localizedDescription)")
                    continuation.resume(throwing: error) // 실패
                }
            }
        }
    }
}
