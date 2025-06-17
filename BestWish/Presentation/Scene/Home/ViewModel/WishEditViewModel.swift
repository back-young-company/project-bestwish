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
        case delete(UUID, Int)
        case complete
    }
    
    struct State {
        let sections: Observable<[WishlistEditSectionModel]>
        let completed: Observable<Void>
        let error: Observable<Error>
    }
    
    private let _sections = BehaviorRelay<[WishlistEditSectionModel]>(value: [])
    private let _completed = PublishRelay<Void>()
    private let _error = PublishRelay<Error>()
    
    private let useCase: WishListUseCase
    
    private var uuidArray: [UUID] = []
    
    private let _action = PublishSubject<Action>()
    var action: AnyObserver<Action> { _action.asObserver() }
    
    let state: State
    
    private let disposeBag = DisposeBag()
    
    init(useCase: WishListUseCase) {
        self.useCase = useCase
        
        state = State(
            sections: _sections.asObservable(),
            completed: _completed.asObservable(),
            error: _error.asObservable()
        )
        
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
                case .delete(let uuid, let item):
                    owner.uuidArray.append(uuid)
                    
                    var wishlists = owner._sections.value[0].items
                    wishlists.remove(at: item)
                    let section = WishlistEditSectionModel(header: "섹션", items: wishlists)
                    owner._sections.accept([section])
                case .complete:
                    Task {
                        do {
                            for id in owner.uuidArray {
                                try await owner.deleteWishListItem(id: id)
                            }
                            owner._completed.accept(())
                        } catch {
                            owner._error.accept(error)
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func getWishLists() async throws -> [WishlistProduct] {
        let result = try await self.useCase.searchWishListItems()
        return result.map { item in
            WishlistProduct(
                uuid: item.id,
                productImageURL: item.imagePathURL,
                brandName: item.brand,
                productName: item.title,
                productSaleRate: "\(item.discountRate)%",
                productPrice: "\(String(item.price))원",
                productDeepLink: item.productURL ?? ""
            )
        }
    }
    
    private func deleteWishListItem(id: UUID) async throws {
        try await self.useCase.deleteWishListItem(id: id)
    }
}
