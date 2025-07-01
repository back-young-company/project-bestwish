//
//  ListSaveViewModel.swift
//  BestWish
//
//  Created by 백래훈 on 6/17/25.
//

import BestWishDomain
import Foundation

internal import RxRelay
internal import RxSwift

/// 상품 추가 View Model
public final class LinkSaveViewModel: ViewModel {

    // MARK: - Action
    enum Action {
        case addProduct(String)
    }

    // MARK: - State
    struct State {
        let completed: Observable<Void>
        let error: Observable<Error>
    }

    // MARK: - Internal Property
    var action: AnyObserver<Action> { _action.asObserver() }
    let state: State

    // MARK: - Private Property
    private let _action = PublishSubject<Action>()

    private let _completed = PublishRelay<Void>()
    private let _error = PublishRelay<Error>()
    
    private let wishListUseCase: WishListUseCase
    private let productSyncUseCase: ProductSyncUseCase

    private let disposeBag = DisposeBag()
    
    public init(
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
                    return owner.addProductToWishList(url)
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - private 메서드
private extension LinkSaveViewModel {
    /// 위시리스트 상품 추가
    func addProductToWishList(_ text: String) {
        Task {
            do {
                let entity = try await productSyncUseCase.sendProductEntity(from: text)
                try await wishListUseCase.addProductToWishList(product: entity)
                _completed.accept(())
            } catch {
                _error.accept(error)
            }
        }
    }
}
