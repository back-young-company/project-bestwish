//
//  HomeSectionModel.swift
//  BestWish
//
//  Created by 백래훈 on 6/10/25.
//

import Foundation

import RxDataSources

/// 섹션 헤더 정의
enum HomeHeader: String {
    case platform = "플랫폼 바로가기"
    case wishlist = "쇼핑몰 위시리스트"
}

/// 섹션 아이템 케이스 정의
enum HomeItem: Equatable {
    case platform(PlatformItem)
    case wishlist(WishListProductItem)
    case wishlistEmpty
}

/// 홈 Section Model
struct HomeSectionModel {
    let header: HomeHeader
    var items: [HomeItem]
}

// MARK: - 홈 Section Model 초기값 설정
extension HomeSectionModel: SectionModelType {
    typealias Item = HomeItem

    init(original: HomeSectionModel, items: [HomeItem]) {
        self = original
        self.items = items
    }
}

/// 플랫폼 Entity
struct PlatformItem: Equatable {
    var platform: ShopPlatform = .musinsa
    let platformName: String
    let platformImage: String
    var platformDeepLink: String
}

/// 위시리스트 Entity
struct WishListProductItem: Equatable {
    let uuid: UUID?
    let productImageURL: String?
    let brandName: String?
    let productName: String?
    let productSaleRate: String?
    let productPrice: String?
    let productDeepLink: String?
}
