//
//  SupabaseError.swift
//  BestWish
//
//  Created by 이수현 on 6/15/25.
//

import Foundation

/// Supabase CRUD 관련 에러
enum SupabaseError: AppErrorProtocol {
    case selectError(Error)
    case updateError(Error)
    case deleteError(Error)
    case insertError(Error)
}

// MARK: - Supabase Error - Description
extension SupabaseError {
    var errorDescription: String? {
        "네트워크 오류가 발생했습니다"
    }

    var debugDescription: String {
        switch self {
        case let .selectError(error):
            "Select Error: \(error.localizedDescription)"
        case let .updateError(error):
            "Update Error: \(error.localizedDescription)"
        case let .deleteError(error):
            "Delete Error: \(error.localizedDescription)"
        case let .insertError(error):
            "Insert Error: \(error.localizedDescription)"
        }
    }
}
