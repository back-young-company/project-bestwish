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
    
    enum Action {
        case viewDidload
    }
    
    struct State {
        let sections: Observable<[HomeSectionModel]>
        let platformFilter: Observable<[(Int, Int)]>
        let platformSequence: Observable<[Int]>
        let error: Observable<Error>
    }
    
    private let _action = PublishSubject<Action>()
    
    private let _sections = BehaviorRelay<[HomeSectionModel]>(value: [])
    private let _platformFilter = BehaviorRelay<[(Int, Int)]>(value: [])
    private let _platformSequence = BehaviorRelay<[Int]>(value: [])
    private let _error = PublishRelay<Error>()
    
    private let useCase: WishListUseCase
    
    var action: AnyObserver<Action> { _action.asObserver() }
    let state: State
    
    private let disposeBag = DisposeBag()
    
    init(useCase: WishListUseCase) {
        self.useCase = useCase
        
        state = State(
            sections: _sections.asObservable(),
            platformFilter: _platformFilter.asObservable(),
            platformSequence: _platformSequence.asObservable(),
            error: _error.asObservable()
        )
        
        self.bind()
    }
    
    private func bind() {
        _action
            .subscribe(with: self) { owner, action in
                switch action {
                case .viewDidload:
                    Task {
                        do {
                            let platformFilters = try await owner.getPlatformInWishList()
                            let platforms = try await owner.getPlatformSequence()
                            let wishLists = try await owner.getWishLists()
                            
                            owner._platformFilter.accept(platformFilters)
                            owner.setDataSources(platforms: platforms, wishLists: wishLists)
                        } catch {
                            owner._error.accept(error)
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func getPlatformSequence() async throws -> [Platform] {
        let result = try await self.useCase.getPlatformSequence()
        return result.map { platform in
            let shopPlatform = ShopPlatform.allCases[platform]
            return Platform(
                platformName: shopPlatform.platformName,
                platformImage: shopPlatform.rawValue,
                platformDeepLink: shopPlatform.platformDeepLink
            )
        }
    }
    
    private func getWishLists() async throws -> [WishlistProduct] {
        let result = try await self.useCase.searchWishListItems()
        return result.map { item in
            WishlistProduct(
                productImageURL: item.imagePathURL,
                brandName: item.brand,
                productName: item.title,
                productSaleRate: "\(item.discountRate)%",
                productPrice: "\(String(item.price))원",
                productDeepLink: item.productURL ?? ""
            )
        }
    }
    
    private func getPlatformInWishList() async throws -> [(Int, Int)] {
        var result = try await self.useCase.getPlatformsInWishList(isEdit: false)
        result.insert((platform: 0, count: 0), at: 0)
        return result
    }
    
    private func setDataSources(platforms: [Platform], wishLists: [WishlistProduct]) {
        let platformsSection = HomeSectionModel(header: .platform, items: platforms.map { .platform($0) })
        
        let wishLists: [HomeItem] = wishLists.isEmpty ? [.wishlistEmpty] : wishLists.map { .wishlist($0) }
        let wishlistSection = HomeSectionModel(header: .wishlist, items: wishLists)

        _sections.accept([platformsSection, wishlistSection])
    }
    
}
