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
    
    func searchResultDeepLink(keyword: String) -> String {
        switch self {
        case .musinsa:
            return "https://musinsaapp.page.link/?link=https%3A%2F%2Fwww.musinsa.com%2Fsearch%2Fgoods%3Fkeyword%3D\(keyword)%26keywordType%3Dpopular%26gf%3DA%26_gf%3DA&apn=com.musinsa.store&isi=1003139529&ibi=com.grab.musinsa&efr=1"
        case .zigzag:
            return "https://zigzag.kr/search?keyword=\(keyword)"
        case .ably:
            return "ably://search?screen_name=SEARCH_RESULT&search_type=POPULAR&query=\(keyword)&airbridge_referrer=airbridge%3Dtrue%26event_uuid%3D466dd3bd-f4b1-467e-a83d-1280ab8d6633%26client_id%3D1e69ec8d-15f6-4006-88df-db431b52f8b4%26channel%3Dairbridge.websdk%26referrer_timestamp%3D1750120734375"
        default: return "notFound"
        }
    }
}
