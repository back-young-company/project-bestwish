//
//  PlatformError.swift
//  BestWish
//
//  Created by Quarang on 6/17/25.
//

import Foundation

/// 플랫폼 에러 생성
enum PlatformError: String, Error {
    case deepLinknotFound = "링크를 찾을 수 없습니다."
    case preparePlatform = "해당 플랫폼은 추후 업데이트될 예정입니다.\n감사합니다."
    case platformNotFound = "플랫폼을 찾을 수 없습니다."
}
