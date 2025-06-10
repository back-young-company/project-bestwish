//
//  HomeSection.swift
//  BestWish
//
//  Created by 백래훈 on 6/10/25.
//

import Foundation

import RxDataSources

enum HomeSection {
    case platform(items: [HomeItem])
    case wishlist(items: [HomeItem])
}

enum HomeItem {
    case platform(Platform)
    case wishlist(WishlistProduct)
}

extension HomeSection: SectionModelType {
    typealias Item = HomeItem

    init(original: HomeSection, items: [HomeItem]) {
        switch original {
        case .platform: self = .platform(items: items)
        case .wishlist: self = .wishlist(items: items)
        }
    }

    var items: [HomeItem] {
        switch self {
        case .platform(let items): return items
        case .wishlist(let items): return items
        }
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
