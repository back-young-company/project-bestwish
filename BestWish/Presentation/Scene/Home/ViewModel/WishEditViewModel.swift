//
//  WishEditViewModel.swift
//  BestWish
//
//  Created by 백래훈 on 6/12/25.
//

import Foundation

import RxSwift

final class WishEditViewModel: ViewModel {
    
    enum Action {
        
    }
    
    struct State {
        let sections = Observable<[WishlistEditSectionModel]>.just([
            WishlistEditSectionModel(header: "섹션", items: [
                WishlistProduct(productImageURL: ProductImage.product1, brandName: "나이키", productName: "반팔 세트 후드 썸머룩 운동복 아노락 오버핏 반바지", productSaleRate: "23%", productPrice: "55,640원", productDeepLink: ""),
                WishlistProduct(productImageURL: ProductImage.product2, brandName: "나이키", productName: "반팔 세트 후드 썸머룩 운동복 아노락 오버핏 반바지", productSaleRate: "23%", productPrice: "55,640원", productDeepLink: ""),
                WishlistProduct(productImageURL: ProductImage.product3, brandName: "나이키", productName: "반팔 세트 후드 썸머룩 운동복 아노락 오버핏 반바지", productSaleRate: "23%", productPrice: "55,640원", productDeepLink: ""),
                WishlistProduct(productImageURL: ProductImage.product4, brandName: "나이키", productName: "반팔 세트 후드 썸머룩 운동복 아노락 오버핏 반바지", productSaleRate: "23%", productPrice: "55,640원", productDeepLink: ""),
                WishlistProduct(productImageURL: ProductImage.product1, brandName: "나이키", productName: "반팔 세트 후드 썸머룩 운동복 아노락 오버핏 반바지", productSaleRate: "23%", productPrice: "55,640원", productDeepLink: "")
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
