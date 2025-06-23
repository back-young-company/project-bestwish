//
//  WishlistEditSection.swift
//  BestWish
//
//  Created by 백래훈 on 6/12/25.
//

import Foundation

import RxDataSources

struct WishlistEditSectionModel {
    let header: String
    var items: [WishlistProduct]
}

extension WishlistEditSectionModel: SectionModelType {
    typealias Item = WishlistProduct

    init(original: WishlistEditSectionModel, items: [WishlistProduct]) {
        self = original
        self.items = items
    }
}
