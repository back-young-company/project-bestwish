//
//  KeyChainError.swift
//  BestWish
//
//  Created by yimkeul on 6/23/25.
//

import Foundation

/// 키체인 에러 종류
enum KeyChainError: AppErrorProtocol {
    case readError
    case saveError
    case deleteError
}

extension KeyChainError {
    var errorDescription: String? {
        "보안 오류가 발생했습니다"
    }

    var debugDescription: String {
        switch self {
        case .readError:
            "KeyChain Read Error"
        case .saveError:
            "KeyChain Save Error"
        case .deleteError:
            "KeyChain Delete Error"
        }
    }
}
