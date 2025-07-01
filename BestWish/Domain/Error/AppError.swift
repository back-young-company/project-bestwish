//
//  AppError.swift
//  BestWish
//
//  Created by 이수현 on 6/16/25.
//

import Foundation

/// 앱 에러 프로토콜 - errorDescription, debugDescription
protocol AppErrorProtocol: LocalizedError {
    var errorDescription: String? { get }
    var debugDescription: String { get }
}

/// 앱 에러 열거형
enum AppError: AppErrorProtocol {
    case supabaseError(AppErrorProtocol)
    case mappingError(AppErrorProtocol)
    case authError(AppErrorProtocol)
    case keyChainError(AppErrorProtocol)
    case coreMLError(AppErrorProtocol)
    case unknown(Error)
}

// MARK: - 앱 에러 Description 정의
extension AppError {
    var errorDescription: String? {
        switch self {
        case let .supabaseError(error),
             let .mappingError(error),
             let .authError(error),
             let .keyChainError(error),
             let .coreMLError(error):
            return error.errorDescription
        case .unknown:
            return "알 수 없는 에러가 발생했습니다."
        }
    }

    var debugDescription: String {
        switch self {
        case let .supabaseError(error),
             let .mappingError(error),
             let .authError(error),
             let .keyChainError(error),
             let .coreMLError(error):
            return error.debugDescription
        case let .unknown(error):
            return "unkownError: \(error.localizedDescription)"
        }
    }
}
