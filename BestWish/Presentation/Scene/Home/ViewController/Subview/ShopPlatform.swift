//
//  ShopPlatform.swift
//  BestWish
//
//  Created by 백래훈 on 6/16/25.
//

import Foundation

enum ShopPlatform: String, CaseIterable {
    case all = "all"
    case musinsa = "musinsa"
    case zigzag = "zigzag"
    case ably = "ably"
    case kream = "kream"
    case brandy = "brandy"
    case tncm = "29cm"
    case oco = "oco"
    case fnoz = "4910"
    case worksout = "worksout"
    case eql = "eql"
    case hiver = "hiver"
    
    var platformName: String {
        switch self {
        case .all:
            return "전체"
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
        case .all, .kream, .brandy, .tncm, .oco, .fnoz, .worksout, .eql, .hiver:
            return "notFound"
        }
    }
}
