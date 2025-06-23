//
//  AppError.swift
//  BestWish
//
//  Created by 이수현 on 6/16/25.
//

import Foundation

protocol AppErrorProtocol: LocalizedError {
    var errorDescription: String? { get }
    var debugDescription: String { get }
}

enum AppError: AppErrorProtocol {
    case supabaseError(AppErrorProtocol)
    case mappingError(AppErrorProtocol)
    case unknown(Error)
}

extension AppError {
    var errorDescription: String? {
        switch self {
        case let .supabaseError(error),
             let .mappingError(error):
            return error.errorDescription
        case .unknown:
            return "알 수 없는 에러가 발생했습니다."
        }
    }

    var debugDescription: String {
        switch self {
        case let .supabaseError(error),
             let .mappingError(error):
            return error.debugDescription
        case let .unknown(error):
            return "unkownError: \(error.localizedDescription)"
        }
    }
}

//TODO: Presentation으로 빼기
extension AppError {
    var alertTitle: String {
        switch self {
        case .supabaseError:
            "네트워크 에러"
        case .mappingError:
            "변환 에러"
        case .unknown:
            "알 수 없는 에러"
        }
    }
}
