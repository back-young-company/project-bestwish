//
//  LoginViewModel.swift
//  BestWish
//
//  Created by yimkeul on 6/7/25.
//

import RxSwift

/// 로그인 View Model
final class LoginViewModel: ViewModel {

    // MARK: - Action
    enum Action {
        case signInKakao
        case signInApple
    }

    // MARK: - State
    struct State { }

    // MARK: - Internal Property
    var action: AnyObserver<Action> { _action.asObserver() }
    let state: State

    // MARK: - Private Property
    private let disposeBag = DisposeBag()
    private let useCase: AccountUseCase
    private let _action = PublishSubject<Action>()

    init(useCase: AccountUseCase) {
        self.useCase = useCase
        state = State()
        bindAction()
    }

    private func bindAction() {
        _action.subscribe(with: self) { owner, action in
            switch action {
            case .signInKakao:
                Task {
                    try await self.useCase.login(type: .kakao)
                }
            case .signInApple:
                Task {
                    try await self.useCase.login(type: .apple)
                }
            }
        }.disposed(by: disposeBag)
    }
}
