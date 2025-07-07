//
//  WishListEditSectionModel.swift
//  BestWish
//
//  Created by 백래훈 on 6/12/25.
//

import Foundation

internal import RxDataSources

/// 위시리스트 편집 Section Model
struct WishListEditSectionModel {
    let header: String
    var items: [WishListProductItem]
}

// MARK: - 위시리스트 편집 Section Model 초기값 설정
extension WishListEditSectionModel: SectionModelType {
    typealias Item = WishListProductItem

    init(original: WishListEditSectionModel, items: [WishListProductItem]) {
        self = original
        self.items = items
    }
}
