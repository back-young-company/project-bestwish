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
}

extension AuthError {
    var errorDescription: String? {
        "네트워크 오류가 발생했습니다"
    }

    var debugDescription: String {
        switch self {
        case .kakaoSignInFailed(let error):
            "Auth Error: \(error.localizedDescription)"
        case .appleSignInFailed(let error):
            "Auth Error: \(error.localizedDescription)"
        }
    }
}
