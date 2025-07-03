//
//  KakaoLogin.swift
//  BestWish
//
//  Created by yimkeul on 6/9/25.
//

import Foundation

internal import Alamofire
public import Supabase

// MARK: - SupabaseOAuth를 활용한 카카오 로그인
extension SupabaseOAuthManagerImpl {

    /// 카카오 로그인
    public func logInKakao() async throws -> Supabase.Session? {
        let redirectURL = Bundle.main.redirectURL
        do {
            let session = try await client.auth.signInWithOAuth(
                provider: Provider.kakao,
                redirectTo: redirectURL
            ) { [weak self] session in
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
            NSLog("error: \(error.localizedDescription)")
            throw AuthError.logInFailed(.kakao, error)
        }
    }

    /// 카카오 회원탈퇴
    public func unlinkKakaoAccount(_ token: String) async throws {
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
                    NSLog("카카오 회원탈퇴 성공. 상태 코드: \(response.response?.statusCode ?? -1)")
                    continuation.resume()

                case let .failure(error):
                    let statusCode = response.response?.statusCode ?? -1
                    let bodyString = response.data.flatMap { String(data: $0, encoding: .utf8) } ?? "응답 바디 없음"
                    NSLog("리프레시 토큰 리보크 실패. HTTP \(statusCode), 응답: \(bodyString), 오류: \(error.localizedDescription)")
                    continuation.resume(throwing: AuthError.withdrawFailed(error))
                }
            }
        }
    }
}
