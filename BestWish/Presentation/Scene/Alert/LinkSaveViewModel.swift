//
//  ListSaveViewModel.swift
//  BestWish
//
//  Created by 백래훈 on 6/17/25.
//

import Foundation

import RxSwift
import RxCocoa

final class LinkSaveViewModel: ViewModel {
    enum Action {
        case addProduct(String)
    }
    
    struct State {
        let completed: Observable<Void>
        let error: Observable<Error>
    }
    
    private let _completed = PublishRelay<Void>()
    private let _error = PublishRelay<Error>()
    
    private let wishListUseCase: WishListUseCase
    private let productSyncUseCase: ProductSyncUseCase

    private let _action = PublishSubject<Action>()
    var action: AnyObserver<Action> { _action.asObserver() }
    
    let state: State
    
    private let disposeBag = DisposeBag()
    
    init(
        wishListUseCase: WishListUseCase,
        productSyncUseCase: ProductSyncUseCase
    ) {
        self.wishListUseCase = wishListUseCase
        self.productSyncUseCase = productSyncUseCase
        state = State(
            completed: _completed.asObservable(),
            error: _error.asObservable()
        )
        self.bind()
    }
    
    private func bind() {
        _action
            .subscribe(with: self) { owner, action in
                switch action {
                case let .addProduct(url):
                    return owner.productToEntity(url)
                }
            }
            .disposed(by: disposeBag)
    }

    private func productToEntity(_ text: String) {
        Task {
            do {
                let entity = try await productSyncUseCase.productToEntity(from: text)
                try await addProductToWishList(product: entity)
                _completed.accept(())
            } catch {
                print("❌ Metadata fetch error: \(error.localizedDescription)")
                // 여기서 에러 넘겨주기
            }
        }
    }

    private func addProductToWishList(product: ProductEntity) async throws {
        try await self.wishListUseCase.addProductToWishList(product: product)
    }
}
