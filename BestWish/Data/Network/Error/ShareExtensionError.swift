//
//  ShareExtensionError.swift
//  BestWish
//
//  Created by 백래훈 on 6/10/25.
//

import Foundation

enum ShareExtensionError: Error {
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
