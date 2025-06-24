//
//  KeyChainError.swift
//  BestWish
//
//  Created by yimkeul on 6/23/25.
//

import Foundation

/// 키체인 에러 종류
enum KeyChainError: AppErrorProtocol {
    case readError(String)
    case saveError
    case deleteError
}

extension KeyChainError {
    var errorDescription: String? {
        "개인정보 오류가 발생했습니다"
    }

    var debugDescription: String {
        switch self {
        case let .readError(detail):
            "KeyChain Read Error : \(detail)"
        case .saveError:
            "KeyChain Save Error"
        case .deleteError:
            "KeyChain Delete Error"
        }
    }
}
