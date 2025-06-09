//
//  MyPageSection.swift
//  BestWish
//
//  Created by 이수현 on 6/9/25.
//

import RxDataSources

//MARK: SectionModelType - RxDataSources

struct MyPageSection {
    var header: String?
    var items: [Item]
}

extension MyPageSection: SectionModelType {
    typealias Item = MyPageCellItem

    init(original: MyPageSection, items: [Item]) {
        self = original
        self.items = items
    }
}

//MARK: 마이페이지 셀 아이템

enum MyPageCellItem {
    case empty
    case seeMore(type: MyPageCellType)
    case basic(type: MyPageCellType)
}

// MARK: 마이페이지 섹션 타입

enum MyPageSectionType: Int, CaseIterable {
    case userAccount
    case userInfo
    case help
    case setting
}

extension MyPageSectionType {
    var title: String {
        switch self {
        case .userInfo: "내 정보"
        case .help: "도움말"
        case .setting: "설정"
        default: ""
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
                MyPageCellType.privacyPolicy
            ]
        case .setting:
            [MyPageCellType.logout]
        default: []
        }
    }
}

//MARK: 마이페이지 셀 타입

enum MyPageCellType {
    case userInfo
    case question
    case termsOfUse
    case privacyPolicy
    case logout
}

extension MyPageCellType {
    var title: String {
        switch self {
        case .userInfo: "회원 정보 관리"
        case .question: "문의사항"
        case .termsOfUse: "서비스 이용 약관"
        case .privacyPolicy: "개인정보 처리 방침"
        case .logout: "로그아웃"
        }
    }

    /// '>' 버튼 유무 표시 프로퍼티
    var showsSeeMoreButton: Bool {
        self == .userInfo
    }
}
