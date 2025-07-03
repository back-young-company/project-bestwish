//
//  CoreMLError.swift
//  BestWish
//
//  Created by Quarang on 6/23/25.
//

import BestWishDomain
import Foundation

/// 앱 에러 케이스 선언
public enum CoreMLError: AppErrorProtocol {
    case modelLoadingFailed(Error)
}

// MARK: - 앱 에러 케이스 별 데이터 선언
extension CoreMLError {
    public var errorDescription: String? {
        "모델을 추출하는데 실패했습니다."
    }

    public var debugDescription: String {
        switch self {
        case let .modelLoadingFailed(error):
            return "CoreML Error: \(error.localizedDescription)"
        }
    }
}
