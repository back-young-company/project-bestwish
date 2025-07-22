//
//  ShopPlatform.swift
//  BestWish
//
//  Created by 백래훈 on 6/16/25.
//

import BestWishDomain
import Foundation

// MARK: - Presentation 레이어에서 사용하기 위한 Extension
extension PlatformEntity {
    
    init?(index: Int) {
        self = Self.allCases[index]
    }

    init?(text: String) {
        guard let matchedCase = Self.allCases.first(where: { text.contains($0.platformImage) }) else { return nil }
        self = matchedCase
    }

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
        case .brandi:
            return "브랜디"
        case ._29cm:
            return "29CM"
        case ._4910:
            return "4910"
        case .hiver:
            return "하이버"
        default:
            return "notFound"
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
        case .brandi:
            return "brandi"
        case ._29cm:
            return "29cm"
        case ._4910:
            return "4910"
        case .hiver:
            return "hiver"
        default:
            return "notFound"
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
        case .brandi:
            return "https://brandi.onelink.me/8g7c"
        case ._29cm:
            return "https://29cm.onelink.me/1080201211"
        case ._4910:
            return "aglo://home?4910"
        case .hiver:
            return "hiverapplication://applink" //"https://hiver.onelink.me/orq2"
        default:
            return "notFound"
        }
    }
    // "hiverapplication%3A%2F%2Fapplink%2Fproducts%2F\(productId)%3Fsearch-word%3D%25EB%25B0%2598%25ED%258C%2594"

    var platformWebLink: String {
        switch self {
        case .musinsa:
            return "https://www.musinsa.com/main/musinsa/recommend"
        case .zigzag:
            return "https://zigzag.kr/?utm_source=sa_google_mo&utm_campaign=sa_01_all_zigzag&utm_medium=search&utm_term=지그재그&utm_content=main&ad_creative=764500111335&ad_group=zk_zk_zigzag_all&campaign=sa_01_all_zigzag&content=main&og_tag_id=144505773&routing_short_id=cc6743&sub_id=search&sub_id_2=kwd-318529266133&term=지그재그&tracking_template_id=7f11ae9bbc3aa24313dbc0a6c6e394b1&ad_type=click&gad_source=1&gad_campaignid=22577300122&gbraid=0AAAAApcZMC9PzOkvaHz_Q7V7IH7uCcK3g&https_deeplink=true&airbridge_referrer=airbridge%3Dtrue%26client_id%3D3a6d0da4-115c-489f-913e-e5854779d00d%26event_uuid%3Dd4015b08-daa7-466d-90da-bda83d734227%26referrer_timestamp%3D1753162143017%26channel%3Dsa_google_mo%26campaign%3Dsa_01_all_zigzag%26tracking_template_id%3D7f11ae9bbc3aa24313dbc0a6c6e394b1%26ad_group%3Dzk_zk_zigzag_all%26ad_creative%3D764500111335%26content%3Dmain%26term%3D%25EC%25A7%2580%25EA%25B7%25B8%25EC%259E%25AC%25EA%25B7%25B8%26sub_id%3Dsearch%26sub_id_2%3Dkwd-318529266133%26og_tag_id%3D144505773%26routing_short_id%3Dcc6743"
        case .ably:
            return "https://m.a-bly.com"
        case .kream:
            return "https://kream.co.kr/?utm_source=google&utm_medium=cpc&utm_campaign=NEW_자사명_수동_MO&utm_term=크림&utm_content=A.+자사명_수동&gad_source=1&gad_campaignid=20006289046&gbraid=0AAAAACRs-HvayVsOKpI5U2j12Y-p_jrlw"
        case .brandi:
            return "https://www.brandi.co.kr/?srsltid=AfmBOoq85X5prwYGp7hcXuBh_9LvCeImZB4EDQ329-lca7-FKfFTraeL"
        case ._4910:
            return "https://4910.kr/?srsltid=AfmBOoqnW3scR3TDYm6-3MxFF_VoaY6-5D4oVQKlJBvXAUXlueiH0O-W&tab=recommend"
        case ._29cm:
            return "https://www.29cm.co.kr"
        case .hiver:
            return "https://www.hiver.co.kr/?gad_source=1&gad_campaignid=22112879411&gbraid=0AAAAAC3D2P3i-J7qTcZNnXU-7D3I8_qOZ"
        default:
            return "notFound"
        }
    }

    var platformAppStoreLink: String {
        switch self {
        case .musinsa:
            return "https://apps.apple.com/kr/app/%EC%98%A8%EB%9D%BC%EC%9D%B8-%ED%8C%A8%EC%85%98-%EC%8A%A4%ED%86%A0%EC%96%B4-%EB%AC%B4%EC%8B%A0%EC%82%AC/id1003139529"
        case .zigzag:
            return "https://apps.apple.com/kr/app/%EC%A7%80%EA%B7%B8%EC%9E%AC%EA%B7%B8-zigzag/id976131101"
        case .ably:
            return "https://apps.apple.com/kr/app/%EC%97%90%EC%9D%B4%EB%B8%94%EB%A6%AC-%EC%A0%84-%EC%83%81%ED%92%88-%EB%AC%B4%EB%A3%8C%EB%B0%B0%EC%86%A1/id1084960428"
        case .kream:
            return "https://apps.apple.com/kr/app/kream-%ED%81%AC%EB%A6%BC-no-1-%ED%95%9C%EC%A0%95%ED%8C%90-%EA%B1%B0%EB%9E%98-%ED%94%8C%EB%9E%AB%ED%8F%BC/id1490580239"
        case .brandi:
            return "https://apps.apple.com/kr/app/%EB%B8%8C%EB%9E%9C%EB%94%94-%EC%9D%B8%EA%B8%B0-%EC%87%BC%ED%95%91%EB%AA%B0%EC%9D%84-%ED%95%9C%EA%B3%B3%EC%97%90/id1005442353"
        case ._4910:
            return "https://apps.apple.com/kr/app/4910-%ED%8C%A8%EC%85%98%EC%9D%B4-%EC%89%AC%EC%9B%8C%EC%A7%80%EB%8A%94-%EC%88%9C%EA%B0%84/id6449024239"
        case ._29cm:
            return "https://apps.apple.com/kr/app/29cm/id789634744"
        case .hiver:
            return "https://apps.apple.com/kr/app/%ED%95%98%EC%9D%B4%EB%B2%84-%EB%82%A8%EC%9E%90%EB%93%A4%EC%9D%98-%ED%95%A9%EB%A6%AC%EC%A0%81-%ED%8C%A8%EC%85%98-%EC%87%BC%ED%95%91/id1346503383"
        default:
            return "notFound"
        }
    }

    func searchResultDeepLink(keyword: String) -> String {
        guard let encoded = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return "" }

        switch self {
        case .musinsa:
            return "https://musinsaapp.page.link/?link=https%3A%2F%2Fwww.musinsa.com%2Fsearch%2Fgoods%3Fkeyword%3D\(encoded)%26keywordType%3Dpopular%26gf%3DA%26_gf%3DA&apn=com.musinsa.store&isi=1003139529&ibi=com.grab.musinsa&efr=1"
        case .zigzag:
            return "https://zigzag.kr/search?keyword=\(encoded)"
        case .ably:
            return "ably://search?screen_name=SEARCH_RESULT&search_type=POPULAR&query=\(keyword)&airbridge_referrer=airbridge%3Dtrue%26event_uuid%3D466dd3bd-f4b1-467e-a83d-1280ab8d6633%26client_id%3D1e69ec8d-15f6-4006-88df-db431b52f8b4%26channel%3Dairbridge.websdk%26referrer_timestamp%3D1750120734375"
        case .kream:
            return "https://kream.airbridge.io/search?keyword=\(encoded)&tab=products&footer=home&deeplink_url=kreamapp%3A%2F%2Fsearch%3Fkeyword%3D\(encoded)%26tab%3Dproducts%26footer%3Dhome&fallback_ios=itunes-appstore&ab_airpage=0&abi_skip_tk=1&airbridge_referrer=airbridge%3Dtrue%26client_id%3D692b8874-5eb9-49a0-a37f-97e31f0eec87%26channel%3Dgoogle%26campaign%3DNEW_%25EC%259E%2590%25EC%2582%25AC%25EB%25AA%2585_%25EC%2588%2598%25EB%258F%2599_MO%26content%3DA.%252B%25EC%259E%2590%25EC%2582%25AC%25EB%25AA%2585_%25EC%2588%2598%25EB%258F%2599%26medium%3Dcpc%26term%3Dkream%26referrer_timestamp%3D1751004482626%26tp_gen_type%3D1221%26keyword%3D\(encoded)%26tab%3Dproducts%26footer%3Dhome%26cta_param_1%3Dweb%2520to%2520app%26cta_param_2%3Dbanner"
        case .brandi:
            return "https://www.brandi.co.kr/search?q=\(encoded)"
        case ._29cm:
            return "https://29cm.onelink.me/1080201211?af_js_web=true&af_ss_ver=2_7_3&pid=29cm_mowebtoapp&c=install_mowebtoapp&af_ad=top_banner&is_retargeting=true&af_click_lookback=7d&af_ss_ui=true&af_sub5=https://www.29cm.co.kr/&af_dp=app29cm%3A%2F%2Fweb%2Fhttps%3A%2F%2Fshop.29cm.co.kr%2Fsearch%3Fkeyword%3D\(encoded)%26sort%3DRECOMMEND%26sortOrder%3DDESC%26defaultSort%3DRECOMMEND%26keywordTypes%3D&deep_link_value=app29cm%3A%2F%2Fweb%2Fhttps%3A%2F%2Fshop.29cm.co.kr%2Fsearch%3Fkeyword%3D\(encoded)%26sort%3DRECOMMEND%26sortOrder%3DDESC%26defaultSort%3DRECOMMEND%26keywordTypes%3D&af_web_dp=https%3A%2F%2Fshop.29cm.co.kr%2Fsearch%3Fkeyword%3D\(encoded)%26sort%3DRECOMMEND%26sortOrder%3DDESC%26defaultSort%3DRECOMMEND%26keywordTypes%3D"
        case ._4910:
            return "https://4910.kr/search?query=\(encoded)&search_type=DIRECT)"
        case .hiver:
            return "https://www.hiver.co.kr/search?q=\(encoded)" //"hiverapplication://applink/https://www.hiver.co.kr/search?q=\(encoded)"
        default:
            return "notFound"
        }
    }
}
