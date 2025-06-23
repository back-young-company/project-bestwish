//
//  AppError+Extension.swift
//  BestWish
//
//  Created by 이수현 on 6/23/25.
//

import Foundation

/// 앱 에러 Alert 설정
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
