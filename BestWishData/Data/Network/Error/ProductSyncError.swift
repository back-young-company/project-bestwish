//
//  ProductSyncError.swift
//  BestWish
//
//  Created by 백래훈 on 6/10/25.
//

import BestWishDomain
import Foundation

/// 상품 동기 Error
enum ProductSyncError: AppErrorProtocol {
    case invaildURL(data: [String: Any])
    case urlExtractionFailed(data: [String: Any])
    case platformDetectionFailed(data: [String: Any])
    case redirectionFailed(data: [String: Any])
    case htmlParsingFailed
    case dataLoadingFailed
    case jsonScriptParsingFailed
    case jsonDecodingFailed
    case invalidProductData
    case unknown
}

extension ProductSyncError {
    var errorDescription: String? {
        return "상품을 추가하는데 실패했습니다."
    }

    var debugDescription: String {
        switch self {
        case .invaildURL:
            return "URL이 유효하지 않습니다."
        case .urlExtractionFailed:
            return "텍스트에서 URL을 추출하지 못했습니다."
        case .platformDetectionFailed:
            return "플랫폼 감지하는데 실패했습니다."
        case .redirectionFailed:
            return "리다이렉션을 실패하였습니다."
        case .htmlParsingFailed:
            return "HTML 파싱에 실패했습니다."
        case .dataLoadingFailed:
            return "데이터 로딩에 실패했습니다."
        case .jsonScriptParsingFailed:
            return "JSON 스크립트 파싱에 실패했습니다."
        case .jsonDecodingFailed:
            return "JSON 디코딩에 실패했습니다."
        case .invalidProductData:
            return "상품 데이터가 유효하지 않습니다."
        case .unknown:
            return "알 수 없는 에러가 발생했습니다."
        }
    }
}
