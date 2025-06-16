//
//  ShopPlatform.swift
//  BestWish
//
//  Created by 백래훈 on 6/16/25.
//

import Foundation

enum ShopPlatform {
    case musinsa
    case zigzag
    case ably
    case kream
    case brandy
    case tncm
    case oco
    case fnoz
    case worksout
    case eql
    case hiver
    
    var platformName: String {
        switch self {
        case .musinsa:
            return "무신사"
        case .zigzag:
            return "지그재그"
        case .ably:
            return "에이블리"
        case .kream:
            return "KREAM"
        case .brandy:
            return "브랜디"
        case .tncm:
            return "29CM"
        case .oco:
            return "OCO"
        case .fnoz:
            return "4910"
        case .worksout:
            return "웍스아웃"
        case .eql:
            return "EQL"
        case .hiver:
            return "하이버"
        }
    }
    
    var platformDeepLink: String {
        switch self {
        case .musinsa:
            return "https://musinsa.onelink.me/PvkC"
        case .zigzag:
            return "zigzag://"
        case .ably:
            return "ably://main"
        case .kream, .brandy, .tncm, .oco, .fnoz, .worksout, .eql, .hiver:
            return "notFound"
        }
    }
}
