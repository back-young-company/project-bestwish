//
//  HomeSectionModel.swift
//  BestWish
//
//  Created by 백래훈 on 6/10/25.
//

import BestWishDomain
import Foundation

internal import RxDataSources

/// 섹션 헤더 정의
enum HomeHeader: String {
    case platform = "플랫폼 바로가기"
    case filter = "쇼핑몰 위시리스트"
    case wishlist = "위시리스트"
}

/// 섹션 아이템 케이스 정의
enum HomeItem: Equatable {
    case platform(PlatformEntity)
    case filter(Int, Bool)
    case wishlist(WishListProductItem)
}

/// 홈 Section Model
struct HomeSectionModel {
    let header: HomeHeader
    var items: [HomeItem]
    var totalCount: Int?
}

// MARK: - 홈 Section Model 초기값 설정
extension HomeSectionModel: SectionModelType {
    typealias Item = HomeItem

    init(original: HomeSectionModel, items: [HomeItem]) {
        self = original
        self.items = items
    }
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
    let platformImage: String?
    let platformName: String?
}
