//
//  HomeSectionModel.swift
//  BestWish
//
//  Created by 백래훈 on 6/10/25.
//

import Foundation

import RxDataSources

enum HomeHeader: String {
    case platform = "플랫폼 바로가기"
    case wishlist = "쇼핑몰 위시리스트"
}

enum HomeItem: Equatable {
    case platform(Platform)
    case wishlist(WishlistProduct)
    case wishlistEmpty
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

struct Platform: Equatable {
    let platformName: String
    let platformImage: String
    let platformDeepLink: String
}

struct WishlistProduct: Equatable {
    let uuid: UUID
    let productImageURL: String
    let brandName: String
    let productName: String
    let productSaleRate: String
    let productPrice: String
    let productDeepLink: String
}
