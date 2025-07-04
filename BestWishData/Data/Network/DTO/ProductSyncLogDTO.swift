//
//  ProductSyncLogDTO.swift
//  BestWishData
//
//  Created by yimkeul on 7/4/25.
//

import Foundation

import BestWishDomain

/// ProductSync 로그 분석 종류
enum ProductSyncLogCase: String {
    case invaildURL
    case platformDetectionFailed
    case redirectionFailed
    case urlExtractionFailed
}

/// ProductSync 로그 DTO
struct ProductSyncLogDTO {
    let type: ProductSyncLogCase
    let platform: Int?
    let productURL: String?
    let deepLink: String?

    init(
        type: ProductSyncLogCase,
        platform: Int? = 0,
        productURL: String? = "Not Found",
        deepLink: String? = "Not Found"
    ) {
        self.type = type
        self.platform = platform
        self.productURL = productURL
        self.deepLink = deepLink
    }

    func toParameters() -> [String:Any] {
        return [
            "type": type.rawValue,
            "platform": platform ?? 0,
            "productURL" : productURL ?? "Not Found",
            "deepLink" : deepLink ?? "Not Found"
        ]
    }
}
