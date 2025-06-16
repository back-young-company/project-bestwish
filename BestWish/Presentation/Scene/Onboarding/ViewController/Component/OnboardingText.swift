//
//  OnboardingText.swift
//  BestWish
//
//  Created by yimkeul on 6/11/25.
//

import Foundation

enum OnboardingText {
    case firstTitle
    case firstDesc
    case secondTitle
    case secondDesc
    case secondCaution

    var value: String {
        switch self {
        case .firstTitle: return "안녕하세요\nBest Wish입니다."
        case .firstDesc: return "당신이 누군지 알려주세요!"
        case .secondTitle: return "프로필을 설정해주세요."
        case .secondDesc: return "나를 표현해봐요!"
        case .secondCaution: return "* 2자이상 10자 이내의 한글, 영문, 숫자 입력 가능합니다."
        }
    }
}


enum PolicyText {
    case title
    case desc
    case privacy
    case service
    case allAgree
    case showPDF

    var value: String {
        switch self {
        case .title:
            return "약관 동의"
        case .desc:
            return "가입을 위해서는 다음 정책들의 동의가 필요합니다."
        case .privacy:
            return "[필수] 개인정보 수집 및 이용에 동의합니다."
        case .service:
            return "[필수] 이용약관에 동의합니다."
        case .allAgree:
            return "모두 동의합니다."
        case .showPDF:
            return "보기"
        }
    }
}
