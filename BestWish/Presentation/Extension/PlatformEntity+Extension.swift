//
//  ShopPlatform.swift
//  BestWish
//
//  Created by 백래훈 on 6/16/25.
//

import Foundation

// MARK: - Presentation 레이어에서 사용하기 위한 Extension
extension PlatformEntity {
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

    var platformImage: String {
        switch self {
        case .all:
            return "all"
        case .musinsa:
            return "musinsa"
        case .zigzag:
            return "zigzag"
        case .ably:
            return "ably"
        case .kream:
            return "kream"
        case .brandy:
            return "brandy"
        case .tncm:
            return "29cm"
        case .oco:
            return "oco"
        case .fnoz:
            return "4910"
        case .worksout:
            return "worksout"
        case .eql:
            return "eql"
        case .hiver:
            return "hiver"
        }
    }

    var platformDeepLink: String {
        switch self {
        case .musinsa:
            return "https://musinsa.onelink.me/PvkC"
        case .zigzag:
            return "zigzag://open/"
        case .ably:
            return "ably://main"
        case .kream:
            return "https://kream.airbridge.io/home/"
        case .all, .brandy, .tncm, .oco, .fnoz, .worksout, .eql, .hiver:
            return "notFound"
        }
    }
    
    func searchResultDeepLink(keyword: String) -> String {
        switch self {
        case .musinsa:
            guard let encodedKeyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return "" }
            return "https://musinsaapp.page.link/?link=https%3A%2F%2Fwww.musinsa.com%2Fsearch%2Fgoods%3Fkeyword%3D\(encodedKeyword)%26keywordType%3Dpopular%26gf%3DA%26_gf%3DA&apn=com.musinsa.store&isi=1003139529&ibi=com.grab.musinsa&efr=1"
        case .zigzag:
            return "https://zigzag.kr/search?keyword=\(keyword)"
        case .ably:
            return "ably://search?screen_name=SEARCH_RESULT&search_type=POPULAR&query=\(keyword)&airbridge_referrer=airbridge%3Dtrue%26event_uuid%3D466dd3bd-f4b1-467e-a83d-1280ab8d6633%26client_id%3D1e69ec8d-15f6-4006-88df-db431b52f8b4%26channel%3Dairbridge.websdk%26referrer_timestamp%3D1750120734375"
        case .kream:
            guard let encoded = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return "" }
            return "https://kream.airbridge.io/search?keyword=\(encoded)&tab=products&footer=home&deeplink_url=kreamapp%3A%2F%2Fsearch%3Fkeyword%3D\(encoded)%26tab%3Dproducts%26footer%3Dhome&fallback_ios=itunes-appstore&ab_airpage=0&abi_skip_tk=1&airbridge_referrer=airbridge%3Dtrue%26client_id%3D692b8874-5eb9-49a0-a37f-97e31f0eec87%26channel%3Dgoogle%26campaign%3DNEW_%25EC%259E%2590%25EC%2582%25AC%25EB%25AA%2585_%25EC%2588%2598%25EB%258F%2599_MO%26content%3DA.%252B%25EC%259E%2590%25EC%2582%25AC%25EB%25AA%2585_%25EC%2588%2598%25EB%258F%2599%26medium%3Dcpc%26term%3Dkream%26referrer_timestamp%3D1751004482626%26tp_gen_type%3D1221%26keyword%3D\(encoded)%26tab%3Dproducts%26footer%3Dhome%26cta_param_1%3Dweb%2520to%2520app%26cta_param_2%3Dbanner"
        default: return "notFound"
        }
    }
}
