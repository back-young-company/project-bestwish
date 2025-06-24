//
//  WishListEditSectionModel.swift
//  BestWish
//
//  Created by 백래훈 on 6/12/25.
//

import Foundation

import RxDataSources

struct WishListEditSectionModel {
    let header: String
    var items: [WishListProductItem]
}

extension WishListEditSectionModel: SectionModelType {
    typealias Item = WishListProductItem

    init(original: WishListEditSectionModel, items: [WishListProductItem]) {
        self = original
        self.items = items
    }
}
