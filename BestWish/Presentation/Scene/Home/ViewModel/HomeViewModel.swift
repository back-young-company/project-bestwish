//
//  HomeViewModel.swift
//  BestWish
//
//  Created by 백래훈 on 6/10/25.
//

import Foundation

import RxSwift
import RxRelay

final class HomeViewModel: ViewModel {
    
    let platformSection: HomeSectionModel =
    HomeSectionModel(header: .platform, items: [
        .platform(Platform(
            platformName: ShopPlatform.musinsa.platformName,
            platformImage: PlatformImage.musinsa,
            platformDeepLink: ShopPlatform.musinsa.platformDeepLink
        )),
        .platform(Platform(
            platformName: ShopPlatform.zigzag.platformName,
            platformImage: PlatformImage.zigzag,
            platformDeepLink: ShopPlatform.zigzag.platformDeepLink
        )),
        .platform(Platform(
            platformName: ShopPlatform.ably.platformName,
            platformImage: PlatformImage.ably,
            platformDeepLink: ShopPlatform.ably.platformDeepLink
        )),
        .platform(Platform(
            platformName: ShopPlatform.kream.platformName,
            platformImage: PlatformImage.kream,
            platformDeepLink: ShopPlatform.kream.platformDeepLink
        )),
        .platform(Platform(
            platformName: ShopPlatform.brandy.platformName,
            platformImage: PlatformImage.brandy,
            platformDeepLink: ShopPlatform.brandy.platformDeepLink
        )),
        .platform(Platform(
            platformName: ShopPlatform.tncm.platformName,
            platformImage: PlatformImage.tncm,
            platformDeepLink: ShopPlatform.tncm.platformDeepLink
        )),
        .platform(Platform(
            platformName: ShopPlatform.oco.platformName,
            platformImage: PlatformImage.oco,
            platformDeepLink: ShopPlatform.oco.platformDeepLink
        )),
        .platform(Platform(
            platformName: ShopPlatform.fnoz.platformName,
            platformImage: PlatformImage.fnoz,
            platformDeepLink: ShopPlatform.fnoz.platformDeepLink
        )),
        .platform(Platform(
            platformName: ShopPlatform.worksout.platformName,
            platformImage: PlatformImage.worksout,
            platformDeepLink: ShopPlatform.worksout.platformDeepLink
        )),
        .platform(Platform(
            platformName: ShopPlatform.eql.platformName,
            platformImage: PlatformImage.eql,
            platformDeepLink: ShopPlatform.eql.platformDeepLink
        )),
        .platform(Platform(
            platformName: ShopPlatform.hiver.platformName,
            platformImage: PlatformImage.hiver,
            platformDeepLink: ShopPlatform.hiver.platformDeepLink
        ))
    ])
    
    enum Action {
        
    }
    
    struct State {
        let sections: Observable<[HomeSectionModel]>
        let platformFilter: Observable<[String]>
    }
    
    private let _action = PublishSubject<Action>()
    var action: AnyObserver<Action> { _action.asObserver() }
    
    private let _sections = BehaviorRelay<[HomeSectionModel]>(value: [])
    private let _platformFilter = BehaviorRelay<[String]>(value: [])
    
    let state: State
    
    private let disposeBag = DisposeBag()
    
    init() {
        let wishlistProducts: [WishlistProduct] = [
//            WishlistProduct(productImageURL: ProductImage.product1, brandName: "나이키", productName: "반팔 세트 후드 썸머룩 운동복 아노락 오버핏 반바지", productSaleRate: "23%", productPrice: "55,640원"),
//            WishlistProduct(productImageURL: ProductImage.product2, brandName: "나이키", productName: "반팔 세트 후드 썸머룩 운동복 아노락 오버핏 반바지", productSaleRate: "23%", productPrice: "55,640원"),
//            WishlistProduct(productImageURL: ProductImage.product3, brandName: "나이키", productName: "반팔 세트 후드 썸머룩 운동복 아노락 오버핏 반바지", productSaleRate: "23%", productPrice: "55,640원"),
//            WishlistProduct(productImageURL: ProductImage.product4, brandName: "나이키", productName: "반팔 세트 후드 썸머룩 운동복 아노락 오버핏 반바지", productSaleRate: "23%", productPrice: "55,640원"),
//            WishlistProduct(productImageURL: ProductImage.product1, brandName: "나이키", productName: "반팔 세트 후드 썸머룩 운동복 아노락 오버핏 반바지", productSaleRate: "23%", productPrice: "55,640원")
        ]

        let wishlistItems: [HomeItem] = wishlistProducts.isEmpty
        ? [.wishlistEmpty]
            : wishlistProducts.map { .wishlist($0) }

        let wishlistSection = HomeSectionModel(header: .wishlist, items: wishlistItems)
        
        let platformFilter = ["전체", "무신사", "에이블리", "지그재그", "KREAM", "브랜디", "29CM", "OCO", "4910", "웍스아웃", "EQL", "하이버"]

        _sections.accept([platformSection, wishlistSection])
        _platformFilter.accept(platformFilter)
        
        state = State(
            sections: _sections.asObservable(),
            platformFilter: _platformFilter.asObservable()
        )
    }
}
