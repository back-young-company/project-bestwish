//
//  PlatformEditSection.swift
//  BestWish
//
//  Created by 백래훈 on 6/12/25.
//

import Foundation

internal import RxDataSources

/// 플랫폼 편집 아이템 정의
struct PlatformEditItem {
    let platformName: String
    let platformImage: String
    let platformCount: Int
}

/// 플랫폼 편집 Section Model
struct PlatformEditSectionModel {
    let header: String
    var items: [PlatformEditItem]
}

// MARK: - 플랫폼 편집 Section Model 초기값 설정
extension PlatformEditSectionModel: SectionModelType {
    typealias Item = PlatformEditItem

    init(original: PlatformEditSectionModel, items: [PlatformEditItem]) {
        self = original
        self.items = items
    }
}
