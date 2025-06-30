//
//  OnboardingData.swift
//  BestWish
//
//  Created by yimkeul on 6/30/25.
//

import Foundation

enum OnboardingData: CaseIterable {
    case first
    case second
    case third
    case fourth
    case fifth

    var value: OnboardingDataInfo {
        switch self {

        case .first:
            return OnboardingDataInfo(title: .firstTitle, desc: .firstDesc, image: .first)
        case .second:
            return OnboardingDataInfo(title: .secondTitle, desc: .secondDesc, image: .second)
        case .third:
            return OnboardingDataInfo(title: .thirdTitle, desc: .thirdDesc, image: .third)
        case .fourth:
            return OnboardingDataInfo(title: .fourthTitle, desc: .fourthDesc, image: .fourth)
        case .fifth:
            return OnboardingDataInfo(title: .fifthTitle, desc: .fifthdDesc, image: .fifth)
        }

    }
}

/// 온보딩에 사용되는 텍스트 모음
enum OnboardingText {
    case firstTitle
    case firstDesc
    case secondTitle
    case secondDesc
    case thirdTitle
    case thirdDesc
    case fourthTitle
    case fourthDesc
    case fifthTitle
    case fifthdDesc


    var value: String {
        switch self {

        case .firstTitle:
            return "모든 위시, 한 곳에"
        case .firstDesc:
            return "홈에서 플랫폼 바로가기와 위시리스트를\n한 눈에 볼 수 있고, 편집도 가능해요!"
        case .secondTitle:
            return "공유만 하면 저장 끝!"
        case .secondDesc:
            return "외부 앱에서 링크 복사 없이,\n공유하기를 눌러 간편 저장이 가능해요!"
        case .thirdTitle:
            return "실시간 패션 캡쳐"
        case .thirdDesc:
            return "패션 캡쳐에서 직접 패션을 촬영하거나,\n이미지를 불러올 수 있어요."
        case .fourthTitle:
            return "캡쳐 후, 영역 편집"
        case .fourthDesc:
            return "원하는 아이템 영역을 직접 지정해 정확한\n스타일 분석이 가능하도록 편집해요."
        case .fifthTitle:
            return "어울리는 키워드 추천까지"
        case .fifthdDesc:
            return "AI가 스타일을 분석해 키워드를 추천해요!\n외부 쇼핑몰로 바로 이동 가능해요."
        }
    }
}


/// 온보딩에 사용되는 이미지
enum OnboardingImage {
    case first
    case second
    case third
    case fourth
    case fifth

    var value: String {
        switch self {
        case .first:
            return "onboardingFirst"
        case .second:
            return "onboardingSecond"
        case .third:
            return "onboardingThird"
        case .fourth:
            return "onboardingFourth"
        case .fifth:
            return "onboardingFifth"
        }
    }
}


