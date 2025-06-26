//
//  PolicyViewModel.swift
//  BestWish
//
//  Created by yimkeul on 6/16/25.
//

import RxRelay
import RxSwift

/// 이용약관 ViewModel
final class PolicyViewModel: ViewModel {

    // MARK: - Actions
    enum Action {
        case privacyCheckboxTapped
        case serviceCheckboxTapped
        case selectAllCheckboxTapped
    }

    // MARK: - States
    struct State {
        let isPrivacySelected: Observable<Bool>
        let isServiceSelected: Observable<Bool>
        let isAllSelected: Observable<Bool>
    }

    // MARK: - Internal Property
    var action: AnyObserver<Action> { _action.asObserver() }
    let state: State

    // MARK: - Private Property
    private let _action = PublishSubject<Action>()

    private let _isPrivacySelected = BehaviorRelay<Bool>(value: false)
    private let _isServiceSelected = BehaviorRelay<Bool>(value: false)
    private let _isAllSelected = BehaviorRelay<Bool>(value: false)

    private let disposeBag = DisposeBag()

    init() {
        state = State(
            isPrivacySelected: _isPrivacySelected.asObservable(),
            isServiceSelected: _isServiceSelected.asObservable(),
            isAllSelected: _isAllSelected.asObservable()
        )
        bindAction()
    }

    private func bindAction() {
        _action
            .subscribe(with: self) { owner, action in
            switch action {
            case .privacyCheckboxTapped:
                let newPrivacy = !owner._isPrivacySelected.value
                owner._isPrivacySelected.accept(newPrivacy)
                owner._isAllSelected.accept(
                    newPrivacy && owner._isServiceSelected.value
                )

            case .serviceCheckboxTapped:
                let newService = !owner._isServiceSelected.value
                owner._isServiceSelected.accept(newService)
                owner._isAllSelected.accept(
                    owner._isPrivacySelected.value && newService
                )

            case .selectAllCheckboxTapped:
                let all = owner._isPrivacySelected.value && owner._isServiceSelected.value
                let newState = !all
                owner._isPrivacySelected.accept(newState)
                owner._isServiceSelected.accept(newState)
                owner._isAllSelected.accept(newState)
            }
        }
            .disposed(by: disposeBag)
    }
}
