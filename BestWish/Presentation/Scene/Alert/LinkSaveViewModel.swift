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
        case product(ProductMetadataDTO)
    }
    
    struct State {
        let completed: Observable<Void>
        let error: Observable<Error>
    }
    
    private let _completed = PublishRelay<Void>()
    private let _error = PublishRelay<Error>()
    
    private let useCase: WishListUseCase
    
    private let _action = PublishSubject<Action>()
    var action: AnyObserver<Action> { _action.asObserver() }
    
    let state: State
    
    private let disposeBag = DisposeBag()
    
    init(useCase: WishListUseCase) {
        self.useCase = useCase
        
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
                case .product(let product):
                    Task {
                        do {
                            try await owner.addProductToWishList(product: product.toEntity())
                            owner._completed.accept(())
                        } catch {
                            owner._error.accept(error)
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func addProductToWishList(product: ProductMetadata) async throws {
        try await self.useCase.addProductToWishList(product: product)
    }
}
