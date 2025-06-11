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
                .platform(Platform(platformName: "무신사", platformImage: PlatformImage.zigzag)),
                .platform(Platform(platformName: "무신사", platformImage: PlatformImage.zigzag)),
                .platform(Platform(platformName: "무신사", platformImage: PlatformImage.zigzag)),
                .platform(Platform(platformName: "무신사", platformImage: PlatformImage.zigzag)),
                .platform(Platform(platformName: "무신사", platformImage: PlatformImage.zigzag)),
                .platform(Platform(platformName: "무신사", platformImage: PlatformImage.zigzag)),
                .platform(Platform(platformName: "무신사", platformImage: PlatformImage.zigzag)),
                .platform(Platform(platformName: "무신사", platformImage: PlatformImage.zigzag))
            ]),
            HomeSectionModel(header: .wishlist, items: [
                .wishlist(WishlistProduct(productImageURL: URL(string: "https://example.com/image.png") ?? URL(fileURLWithPath: ""), brandName: "나이키", productName: "가을 바람막이", productSaleRate: "15%", productPrice: "46,000원")),
                .wishlist(WishlistProduct(productImageURL: URL(string: "https://example.com/image.png") ?? URL(fileURLWithPath: ""), brandName: "나이키", productName: "가을 바람막이", productSaleRate: "15%", productPrice: "46,000원")),
                .wishlist(WishlistProduct(productImageURL: URL(string: "https://example.com/image.png") ?? URL(fileURLWithPath: ""), brandName: "나이키", productName: "가을 바람막이", productSaleRate: "15%", productPrice: "46,000원")),
                .wishlist(WishlistProduct(productImageURL: URL(string: "https://example.com/image.png") ?? URL(fileURLWithPath: ""), brandName: "나이키", productName: "가을 바람막이", productSaleRate: "15%", productPrice: "46,000원")),
                .wishlist(WishlistProduct(productImageURL: URL(string: "https://example.com/image.png") ?? URL(fileURLWithPath: ""), brandName: "나이키", productName: "가을 바람막이", productSaleRate: "15%", productPrice: "46,000원"))
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
