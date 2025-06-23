//
//  WishListEditSection.swift
//  BestWish
//
//  Created by 백래훈 on 6/12/25.
//

import Foundation

import RxDataSources

struct WishlistEditSectionModel {
    let header: String
    var items: [WishListProductItem]
}

extension WishlistEditSectionModel: SectionModelType {
    typealias Item = WishListProductItem

    init(original: WishlistEditSectionModel, items: [WishListProductItem]) {
        self = original
        self.items = items
    }
}
