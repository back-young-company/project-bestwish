//
//  AuthError.swift
//  BestWish
//
//  Created by yimkeul on 6/17/25.
//

import BestWishDomain
import Foundation

/// 사용자 인증 정보 관련 에러 모음
enum AuthError: AppErrorProtocol {
    case logInFailed(SocialType, Error)
    case logOutFailed(Error)
    case appleRequestAccessTokenFailed(Error)
    case encodeParsingTokenError(String)
    case supabaseRequestSecretCodeFailed(Error)
    case supabaseRequestSecretCodeNil
    case withdrawFailed(Error)
    case appleDidCompleteFailed
    case supabaseSetSessionFailed(Error)
    case missProvider
    case supabaseRequestRoleFailed(Error)
    case supabaseRPCFailed(Error)
}

// MARK: - AuthError 케이스 별 텍스트
extension AuthError {
    var errorDescription: String? {
        "인증 오류가 발생했습니다"
    }

    var debugDescription: String {
        switch self {
        case let .logInFailed(socialType, error):
            "\(socialType) SignIn Error: \(error.localizedDescription)"
        case let .logOutFailed(error):
            "SignOut Error: \(error.localizedDescription)"
        case let .withdrawFailed(error):
            "Withdraw Error: \(error.localizedDescription)"

            /// 애플
        case let .appleRequestAccessTokenFailed(error):
            "Apple Access Token Error: \(error.localizedDescription)"
        case .appleDidCompleteFailed:
            "Apple DidCompleted Failed"
        case let .encodeParsingTokenError(field):
            "Encoding Parsing Access Token Error : \(field)"

            /// Supabase
        case let .supabaseRequestRoleFailed(error):
            "Supabase Request Role Failed : \(error.localizedDescription)"
        case let .supabaseRequestSecretCodeFailed(error):
            "Supabase Request Client Secret Error : \(error.localizedDescription)"
        case .supabaseRequestSecretCodeNil:
            "Supabase Request Client Secret Return Nil"
        case let .supabaseSetSessionFailed(error):
            "Supabase Set Session Failed : \(error.localizedDescription)"
        case let .supabaseRPCFailed(error):
            "Supabase RPC Failed : \(error.localizedDescription)"
        case .missProvider:
            "Missing Provider"

        }
    }
}
