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
        case .supabaseError(let error),
                .mappingError(let error):
            return error.errorDescription
        case .unknown:
            return "알 수 없는 에러가 발생했습니다."
        }
    }

    var debugDescription: String {
        switch self {
        case .supabaseError(let error),
                .mappingError(let error):
            return error.debugDescription
        case .unknown(let error):
            return "unkownError: \(error.localizedDescription)"
        }
    }
}
