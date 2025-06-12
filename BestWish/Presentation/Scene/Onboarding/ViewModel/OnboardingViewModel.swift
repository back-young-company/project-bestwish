//
//  OnboardingViewModel.swift
//  BestWish
//
//  Created by yimkeul on 6/9/25.
//

import Foundation
import RxSwift
import RxRelay

final class OnboardingViewModel: ViewModel {

    private let dummyUseCase: DummyUseCase
    private let disposeBag = DisposeBag()

    enum Action {
        case selectedProfileIndex(Int)
    }

    struct State {
        let userInput: Observable<OnboardingDisplay>
    }

    private let _action = PublishSubject<Action>()
    var action: AnyObserver<Action> { _action.asObserver() }

    private let _userInput = BehaviorRelay<OnboardingDisplay> (value:
        OnboardingDisplay(
        profileImageIndex: 0,
        nickname: nil)
    )
    let state: State

    init(dummyUseCase: DummyUseCase) {
        self.dummyUseCase = dummyUseCase
        state = State(
            userInput: _userInput.asObservable())

        bindAction()
    }

    private func bindAction() {
        _action.subscribe(with: self) { owner, action in
            switch action {
            case .selectedProfileIndex(let index):
                owner.updateProfileImage(with: index)
            }
        }.disposed(by: disposeBag)
    }
    private func updateProfileImage(with index: Int) {
        var userInput = _userInput.value
        userInput.updateProfileImageIndex(to: index)
        _userInput.accept(userInput)
    }
}
