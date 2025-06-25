//
//  ShareViewModel.swift
//  BestWishShareExtension
//
//  Created by 백래훈 on 6/18/25.
//

import Foundation

import RxSwift
import RxRelay

final class ShareViewModel: ViewModel {
    enum Action {
        case addProduct(NSItemProvider)
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
                case let .addProduct(provider):
                    return owner.handleSharedItem(from: provider)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func addProductToWishList(product: ProductEntity) async throws {
        try await self.wishListUseCase.addProductToWishList(product: product)

    }
}

private extension ShareViewModel {
    // 🔍 provider의 타입에 따라 URL 또는 텍스트로 처리 분기
    func handleSharedItem(from provider: NSItemProvider) {
        if provider.hasItemConformingToTypeIdentifier("public.url") {
            provider.loadItem(forTypeIdentifier: "public.url", options: nil) { [weak self] item, _ in
                guard let self, let url = item as? URL else { return }
                self.handleSharedText(url.absoluteString)
            }
        } else if provider.hasItemConformingToTypeIdentifier("public.text") {
            provider.loadItem(forTypeIdentifier: "public.text", options: nil) { [weak self] item, _ in
                guard let self, let text = item as? String else { return }
                self.handleSharedText(text)
            }
        }
    }

    func handleSharedText(_ text: String) {
        Task {
            do {
                let entity = try await productSyncUseCase.productDTOToEntity(from: text)
                try await addProductToWishList(product: entity)
                _completed.accept(())
            } catch {
                print("❌ Metadata fetch error: \(error.localizedDescription)")
                // 여기서 에러 넘겨주기
            }
        }
    }
}
