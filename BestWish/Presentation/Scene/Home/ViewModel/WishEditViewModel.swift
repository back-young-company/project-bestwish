//
//  WishEditViewModel.swift
//  BestWish
//
//  Created by 백래훈 on 6/12/25.
//

import Foundation

import RxSwift
import RxRelay

final class WishEditViewModel: ViewModel {
    
    enum Action {
        case viewDidLoad
    }
    
    struct State {
        let sections: Observable<[WishlistEditSectionModel]>
    }
    
    private let _sections = BehaviorRelay<[WishlistEditSectionModel]>(value: [])
    
    private let useCase: WishListUseCase
    
    private let _action = PublishSubject<Action>()
    var action: AnyObserver<Action> { _action.asObserver() }
    
    let state: State
    
    private let disposeBag = DisposeBag()
    
    init(useCase: WishListUseCase) {
        self.useCase = useCase
        
        state = State(sections: _sections.asObservable())
        
        self.bind()
    }
    
    private func bind() {
        _action
            .subscribe(with: self) { owner, action in
                switch action {
                case .viewDidLoad:
                    Task {
                        let wishlists = try await owner.getWishLists()
                        let section = WishlistEditSectionModel(header: "섹션", items: wishlists)
                        owner._sections.accept([section])
                    }
                }
            }
            .disposed(by: disposeBag)
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
}
