//
//  ProductSyncError.swift
//  BestWish
//
//  Created by 백래훈 on 6/10/25.
//

import Foundation

/// 상품 동기 Error
enum ProductSyncError: Error {
    case invaildURL
    case platformDetectionFailed
    case redirectionFailed
    case htmlParsingFailed
    case dataLoadingFailed
    case jsonScriptParsingFailed
    case jsonDecodingFailed
    case invalidProductData
    case unknown
}
