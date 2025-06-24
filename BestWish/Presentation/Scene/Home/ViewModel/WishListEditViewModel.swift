//
//  WishListEditViewModel.swift
//  BestWish
//
//  Created by 백래훈 on 6/12/25.
//

import Foundation

import RxSwift
import RxRelay

/// 위시리스트 편집 View Model
final class WishListEditViewModel: ViewModel {

    // MARK: - Action
    enum Action {
        case viewDidLoad
        case delete(UUID, Int)
        case complete
    }

    // MARK: - State
    struct State {
        let sections: Observable<[WishListEditSectionModel]>
        let completed: Observable<Void>
        let error: Observable<Error>
    }

    // MARK: - Internal Property
    var action: AnyObserver<Action> { _action.asObserver() }
    let state: State

    // MARK: - Private Property
    private let _action = PublishSubject<Action>()
    private let _sections = BehaviorRelay<[WishListEditSectionModel]>(value: [])
    private let _completed = PublishRelay<Void>()
    private let _error = PublishRelay<Error>()

    private var uuidArray: [UUID] = []

    private let useCase: WishListUseCase
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
                        let section = WishListEditSectionModel(header: "섹션", items: wishlists)
                        owner._sections.accept([section])
                    }
                case .delete(let uuid, let item):
                    owner.uuidArray.append(uuid)

                    var wishlists = owner._sections.value[0].items
                    wishlists.remove(at: item)
                    let section = WishListEditSectionModel(header: "섹션", items: wishlists)
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
}

// MARK: - private 메서드
private extension WishListEditViewModel {
    /// Supabase 위시리스트 가져오기
    func getWishLists() async throws -> [WishListProductItem] {
        let result = try await self.useCase.searchWishListItems()
        return result.map { item in
            WishListProductItem(
                uuid: item.id!,
                productImageURL: item.imagePathURL!,
                brandName: item.brand!,
                productName: item.title!,
                productSaleRate: "\(item.discountRate)%",
                productPrice: "\(item.price?.formattedPrice())원",
                productDeepLink: item.productURL ?? ""
            )
        }
    }

    /// Supabase 위시리스트 삭제
    private func deleteWishListItem(id: UUID) async throws {
        try await self.useCase.deleteWishListItem(id: id)
    }
}
