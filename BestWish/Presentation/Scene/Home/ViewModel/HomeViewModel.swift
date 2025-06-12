//
//  HomeViewModel.swift
//  BestWish
//
//  Created by 백래훈 on 6/10/25.
//

import Foundation

import RxSwift

final class HomeViewModel: ViewModel {
    
    enum Action {
        
    }
    
    struct State {
        let sections = Observable<[HomeSectionModel]>.just([
            HomeSectionModel(header: .platform, items: [
                .platform(Platform(platformName: "무신사", platformImage: PlatformImage.musinsa)),
                .platform(Platform(platformName: "지그재그", platformImage: PlatformImage.zigzag)),
                .platform(Platform(platformName: "에이블리", platformImage: PlatformImage.ably)),
                .platform(Platform(platformName: "KREAM", platformImage: PlatformImage.kream)),
                .platform(Platform(platformName: "브랜디", platformImage: PlatformImage.brandy)),
                .platform(Platform(platformName: "29CM", platformImage: PlatformImage.tncm)),
                .platform(Platform(platformName: "OCO", platformImage: PlatformImage.oco)),
                .platform(Platform(platformName: "4910", platformImage: PlatformImage.fnoz)),
                .platform(Platform(platformName: "웍스아웃", platformImage: PlatformImage.worksout)),
                .platform(Platform(platformName: "EQL", platformImage: PlatformImage.eql)),
                .platform(Platform(platformName: "하이버", platformImage: PlatformImage.hiver))
            ]),
            HomeSectionModel(header: .wishlist, items: [
                .wishlist(WishlistProduct(productImageURL: ProductImage.product1, brandName: "나이키", productName: "반팔 세트 후드 썸머룩 운동복 아노락 오버핏 반바지", productSaleRate: "23%", productPrice: "55,640원")),
                .wishlist(WishlistProduct(productImageURL: ProductImage.product2, brandName: "나이키", productName: "반팔 세트 후드 썸머룩 운동복 아노락 오버핏 반바지", productSaleRate: "23%", productPrice: "55,640원")),
                .wishlist(WishlistProduct(productImageURL: ProductImage.product3, brandName: "나이키", productName: "반팔 세트 후드 썸머룩 운동복 아노락 오버핏 반바지", productSaleRate: "23%", productPrice: "55,640원")),
                .wishlist(WishlistProduct(productImageURL: ProductImage.product4, brandName: "나이키", productName: "반팔 세트 후드 썸머룩 운동복 아노락 오버핏 반바지", productSaleRate: "23%", productPrice: "55,640원")),
                .wishlist(WishlistProduct(productImageURL: ProductImage.product1, brandName: "나이키", productName: "반팔 세트 후드 썸머룩 운동복 아노락 오버핏 반바지", productSaleRate: "23%", productPrice: "55,640원"))
            ])
        ])
    }
    
    private let _action = PublishSubject<Action>()
    var action: AnyObserver<Action> { _action.asObserver() }
    
    let state: State
    
    private let disposeBag = DisposeBag()
    
    init() {
        state = State()
    }
}
