//
//  ShareViewModel.swift
//  BestWishShareExtension
//
//  Created by 백래훈 on 6/18/25.
//

import BestWishDomain
import Foundation

internal import RxSwift
internal import RxRelay

public final class ShareViewModel: ViewModel {
    enum Action {
        case addProduct(NSItemProvider)
    }
    
    struct State {
        let completed: Observable<Void>
        let error: Observable<Error>
    }
    
    private let _completed = PublishRelay<Void>()
    private let _error = PublishRelay<Error>()

    private let userDefaultsUseCase: UserDefaultsUseCase
    private let wishListUseCase: WishListUseCase
    private let productSyncUseCase: ProductSyncUseCase

    private let _action = PublishSubject<Action>()
    var action: AnyObserver<Action> { _action.asObserver() }
    
    let state: State
    
    private let disposeBag = DisposeBag()
    
    public init(
        userDefaultsUseCase: UserDefaultsUseCase,
        wishListUseCase: WishListUseCase,
        productSyncUseCase: ProductSyncUseCase
    ) {
        self.userDefaultsUseCase = userDefaultsUseCase
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

                    // ✅ URL 형식만 처리 → 크림 텍스트 무시됨
                    guard !text.hasPrefix("[KREAM]") else { return }
                    self.handleSharedText(text)
                }
            }
        }

    func handleSharedText(_ text: String) {
        Task {
            do {
                let entity = try await productSyncUseCase.sendProductEntity(from: text)
                try await addProductToWishList(product: entity)
                markAddProductFlag()
                _completed.accept(())                
            } catch {
                _error.accept(error)
            }
        }
    }
}

private extension ShareViewModel {
    func markAddProductFlag() {
        userDefaultsUseCase.set(true, forKey: "AddProduct")
    }
}
