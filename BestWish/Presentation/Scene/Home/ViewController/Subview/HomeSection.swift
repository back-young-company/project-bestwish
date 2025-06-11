//
//  HomeSection.swift
//  BestWish
//
//  Created by 백래훈 on 6/10/25.
//

import Foundation

import RxDataSources

enum HomeHeader {
    case platform
    case wishlist
}

enum HomeItem {
    case platform(Platform)
    case wishlist(WishlistProduct)
}

struct HomeSectionModel {
    let header: HomeHeader
    var items: [HomeItem]
}

extension HomeSectionModel: SectionModelType {
    typealias Item = HomeItem

    init(original: HomeSectionModel, items: [HomeItem]) {
        self = original
        self.items = items
    }
}

struct Platform {
    let platformName: String
    let platformImage: String
}

struct WishlistProduct {
    let productImageURL: URL
    let brandName: String
    let productName: String
    let productSaleRate: String
    let productPrice: String
}
