//
//  SupabaseError.swift
//  BestWish
//
//  Created by 이수현 on 6/15/25.
//

import Foundation

enum SupabaseError: AppErrorProtocol {
    case selectError(Error)
    case updateError(Error)
    case deleteError(Error)
    case insertError(Error)
}

extension SupabaseError {
    var errorDescription: String? {
        "네트워크 오류가 발생했습니다"
    }

    var debugDescription: String {
        switch self {
        case .selectError(let error):
            "Select Error: \(error.localizedDescription)"
        case .updateError(let error):
            "Update Error: \(error.localizedDescription)"
        case .deleteError(let error):
            "Delete Error: \(error.localizedDescription)"
        case .insertError(let error):
            "Insert Error: \(error.localizedDescription)"
        }
    }
}
