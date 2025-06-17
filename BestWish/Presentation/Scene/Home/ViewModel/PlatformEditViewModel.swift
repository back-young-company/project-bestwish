//
//  PlatformEditViewModel.swift
//  BestWish
//
//  Created by 백래훈 on 6/12/25.
//

import Foundation

import RxSwift
import RxRelay

final class PlatformEditViewModel: ViewModel {
    
    enum Action {
        case viewDidLoad
        case updatePlatformEdit([Int])
    }
    
    struct State {
        let sections: Observable<[PlatformEditSectionModel]>
        let sendDelegate: Observable<Void>
        let error: Observable<Error>
    }
    
    private let _action = PublishSubject<Action>()
    
    private let _sections = BehaviorRelay<[PlatformEditSectionModel]>(value: [])
    private let _sendDelegate = PublishRelay<Void>()
    private let _error = PublishRelay<Error>()
    
    private let useCase: WishListUseCase
    
    var action: AnyObserver<Action> { _action.asObserver() }
    let state: State
    
    private let disposeBag = DisposeBag()
    
    init(useCase: WishListUseCase) {
        self.useCase = useCase
        
        state = State(
            sections: _sections.asObservable(),
            sendDelegate: _sendDelegate.asObservable(),
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
                        do {
                            let items = try await owner.getPlatformSequence(isEdit: true)
                            owner.setDataSources(items: items)
                        } catch {
                            owner._error.accept(error)
                        }
                    }
                case .updatePlatformEdit(let indices):
                    Task {
                        do {
                            try await owner.updatePlatformSequence(indices)
                            let items = try await owner.getPlatformSequence(isEdit: true)
                            owner.setDataSources(items: items)
                            owner._sendDelegate.accept(())
                        } catch {
                            owner._error.accept(error)
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func getPlatformSequence(isEdit: Bool) async throws -> [PlatformEdit] {
        let result = try await self.useCase.getPlatformsInWishList(isEdit: isEdit)
        return result.map { tupple in
            let shopPlatform = ShopPlatform.allCases[tupple.platform]
            return PlatformEdit(
                platformName: shopPlatform.platformName,
                platformImage: shopPlatform.rawValue,
                platformCount: tupple.count
            )
        }
    }
    
    private func updatePlatformSequence(_ sequence: [Int]) async throws {
        try await self.useCase.updatePlatformSequence(to: sequence)
    }
    
    private func setDataSources(items: [PlatformEdit]) {
        let sections = PlatformEditSectionModel(header: "헤더", items: items)
        _sections.accept([sections])
    }
}
