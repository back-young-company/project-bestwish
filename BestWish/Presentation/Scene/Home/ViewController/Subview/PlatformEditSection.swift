//
//  PlatformEditSection.swift
//  BestWish
//
//  Created by 백래훈 on 6/12/25.
//

import Foundation

import RxDataSources

struct PlatformEditSectionModel {
    let header: String
    var items: [PlatformEdit]
}

extension PlatformEditSectionModel: SectionModelType {
    typealias Item = PlatformEdit

    init(original: PlatformEditSectionModel, items: [PlatformEdit]) {
        self = original
        self.items = items
    }
}

struct PlatformEdit {
    let platformName: String
    let platformImage: String
    let platformCount: Int
}
