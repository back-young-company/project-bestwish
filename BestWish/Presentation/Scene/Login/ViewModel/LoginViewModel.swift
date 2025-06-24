//
//  LoginViewModel.swift
//  BestWish
//
//  Created by yimkeul on 6/7/25.
//

import Foundation

import RxSwift

final class LoginViewModel: ViewModel {

    private let disposeBag = DisposeBag()
    private let useCase: AccountUseCase

    enum Action {
        case signInKakao
        case signInApple
    }

    struct State { }

    private let _action = PublishSubject<Action>()
    var action: AnyObserver<Action> { _action.asObserver() }

    let state: State

    init(useCase: AccountUseCase) {
        self.useCase = useCase
        state = State()
        bindAction()
    }

    private func bindAction() {
        _action.subscribe(with: self) { owner, action in
            Task {
                switch action {
                case .signInKakao:
                    try await self.useCase.login(type: .kakao)
                case .signInApple:
                    try await self.useCase.login(type: .apple)
                }
            }

        }.disposed(by: disposeBag)
    }
}
