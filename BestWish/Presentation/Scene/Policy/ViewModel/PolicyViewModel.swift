//
//  PolicyViewModel.swift
//  BestWish
//
//  Created by yimkeul on 6/16/25.
//

import Foundation
import RxSwift
import RxRelay

final class PolicyViewModel: ViewModel {

    private let disposeBag = DisposeBag()

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

    // MARK: - Inputs
    private let _action = PublishSubject<Action>()
    var action: AnyObserver<Action> { _action.asObserver() }

    // MARK: - Outputs
    private let _isPrivacySelected = BehaviorRelay<Bool>(value: false)
    private let _isServiceSelected = BehaviorRelay<Bool>(value: false)
    private let _isAllSelected = BehaviorRelay<Bool>(value: false)

    let state: State

    // MARK: - Initializer, Deinit, requiered
    init() {
        state = State(
            isPrivacySelected: _isPrivacySelected.asObservable(),
            isServiceSelected: _isServiceSelected.asObservable(),
            isAllSelected: _isAllSelected.asObservable()
        )

        bindAction()
    }

    // MARK: - Bind
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

    // MARK: Methods

}
