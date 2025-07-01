//
//  MyPageSection.swift
//  BestWish
//
//  Created by 이수현 on 6/9/25.
//

import Foundation

import RxDataSources

/// 마이페이지 SectionModelType - RxDataSources
struct MyPageSection {
    var header: String?
    var footer: String?
    var items: [Item]
}

// MARK: - SectionModelType 채택
extension MyPageSection: SectionModelType {
    typealias Item = MyPageCellItem

    init(original: MyPageSection, items: [Item]) {
        self = original
        self.footer = " "
        self.items = items
    }
}

/// 마이페이지 셀 아이템
enum MyPageCellItem {
    case seeMore(type: MyPageCellType)
    case basic(type: MyPageCellType)
}

/// 마이페이지 섹션 타입
enum MyPageSectionType: Int, CaseIterable {
    case userInfo
    case help
    case setting
}

// MARK: - MyPageSectionType 프로퍼티 설정
extension MyPageSectionType {
    var title: String {
        switch self {
        case .userInfo: "내 정보"
        case .help: "도움말"
        case .setting: "설정"
        }
    }

    var cell: [MyPageCellType] {
        switch self {
        case .userInfo:
            [MyPageCellType.userInfo]
        case .help:
            [
                MyPageCellType.question,
                MyPageCellType.termsOfUse,
                MyPageCellType.privacyPolicy,
                MyPageCellType.onboarding
            ]
        case .setting:
            [MyPageCellType.logout]
        }
    }
}

/// 마이페이지 셀 타입
enum MyPageCellType {
    case userInfo
    case question
    case termsOfUse
    case privacyPolicy
    case onboarding
    case logout

    init?(indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 0): self = .userInfo
        case (1, 0): self = .question
        case (1, 1): self = .termsOfUse
        case (1, 2): self = .privacyPolicy
        case (1, 3): self = .onboarding
        case (2, 0): self = .logout
        default: return nil
        }
    }
}

// MARK: - MyPageCellType 프로퍼티 설정
extension MyPageCellType {
    var title: String {
        switch self {
        case .userInfo: "회원 정보 관리"
        case .question: "문의사항"
        case .termsOfUse: "서비스 이용 약관"
        case .privacyPolicy: "개인정보 처리 방침"
        case .onboarding: "서비스 가이드"
        case .logout: "로그아웃"

        }
    }

    /// '>' 버튼 유무 표시 프로퍼티
    var showsSeeMoreButton: Bool {
        self == .userInfo
    }
}

// MARK: - 테스트용
#if DEBUG
extension MyPageCellType: CaseIterable { }
#endif
