//
//  AuthError.swift
//  BestWish
//
//  Created by yimkeul on 6/17/25.
//

import Foundation

enum AuthError: AppErrorProtocol {
    case kakaoSignInFailed(Error)
    case appleSignInFailed(Error)
    case signOutFailed(Error)
    case appleRequestAccessTokenFailed(Error)
    case encodeParsingTokenError(String)
    case supabaseRequestSecretCodeFailed(Error)
    case supabaseRequestSecretCodeNil
    case withdrawFailed(Error)
    case appleDidCompleteFailed
    case setSessionFailed(Error)
    case missProvider
}

extension AuthError {
    var errorDescription: String? {
        "인증 오류가 발생했습니다"
    }

    var debugDescription: String {
        switch self {
        case let .kakaoSignInFailed(error):
            "Kakao SignIn Error: \(error.localizedDescription)"
        case let .appleSignInFailed(error):
            "Auth Error: \(error.localizedDescription)"
        case let .signOutFailed(error):
            "SignOut Error: \(error.localizedDescription)"
        case let .appleRequestAccessTokenFailed(error):
            "Apple Access Token Error: \(error.localizedDescription)"
        case let .encodeParsingTokenError(field):
            "Encoding Parsing Access Token Error : \(field)"
        case let .supabaseRequestSecretCodeFailed(error):
            "Supabase Request Client Secret Error : \(error.localizedDescription)"
        case .supabaseRequestSecretCodeNil:
            "Supabase Request Client Secret Return Nil"
        case let .withdrawFailed(error):
            "Withdraw Error: \(error.localizedDescription)"
        case .appleDidCompleteFailed:
            "Apple DidCompleted Failed"
        case let .setSessionFailed(error):
            "Supabase Set Session Failed : \(error.localizedDescription)"
        case .missProvider:
            "Missing Provider"
        }
    }
}
