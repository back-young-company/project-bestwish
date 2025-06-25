//
//  PlatformEditViewModel.swift
//  BestWish
//
//  Created by 백래훈 on 6/12/25.
//

import Foundation

import RxSwift
import RxRelay

/// 플랫폼 View Model
final class PlatformEditViewModel: ViewModel {

    // MARK: - Action
    enum Action {
        case viewDidLoad
        case itemMoved([PlatformEditItem])
        case updatePlatformEdit([Int])
    }

    // MARK: - State
    struct State {
        let sections: Observable<[PlatformEditSectionModel]>
        let sendDelegate: Observable<Void>
        let error: Observable<Error>
    }

    // MARK: - Internal Property
    var action: AnyObserver<Action> { _action.asObserver() }
    let state: State

    // MARK: - Private Property
    private let _action = PublishSubject<Action>()
    private let _sections = BehaviorRelay<[PlatformEditSectionModel]>(value: [])
    private let _sendDelegate = PublishRelay<Void>()
    private let _error = PublishRelay<Error>()

    private let useCase: WishListUseCase
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
                case .itemMoved(let platforms):
                    var section = owner._sections.value
                    section[0] = PlatformEditSectionModel(header: "헤더", items: platforms)
                    owner._sections.accept(section)
                    
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
}

private extension PlatformEditViewModel {
    /// Supabase 플랫폼 시퀀스 가져오기
    func getPlatformSequence(isEdit: Bool) async throws -> [PlatformEditItem] {
        let result = try await self.useCase.getPlatformsInWishList(isEdit: isEdit)
        return result.map { tupple in
            let shopPlatform = PlatformEntity.allCases[tupple.platform]
            return PlatformEditItem(
                platformName: shopPlatform.platformName,
                platformImage: shopPlatform.platformImage,
                platformCount: tupple.count
            )
        }
    }

    /// Supabase 플랫폼 시퀀스 업데이트
    func updatePlatformSequence(_ sequence: [Int]) async throws {
        try await self.useCase.updatePlatformSequence(to: sequence)
    }

    /// section model 설정 및 전달
    func setDataSources(items: [PlatformEditItem]) {
        let sections = PlatformEditSectionModel(header: "헤더", items: items)
        _sections.accept([sections])
    }
}
