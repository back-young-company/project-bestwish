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
    private let _action = PublishSubject<Action>()

    private let useCase: AccountUseCase
    private let disposeBag = DisposeBag()
    private let dummyCoordinator = DummyCoordinator.shared

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
                    let didOnboarding = try await self.useCase.login(type: .kakao)
                    if didOnboarding {
                        self.dummyCoordinator.showMainView()
                    } else {
                        self.dummyCoordinator.showOnboardingView()
                    }
                }
            case .signInApple:
                Task {
                    let didOnboarding = try await self.useCase.login(type: .apple)
                    if didOnboarding {
                        self.dummyCoordinator.showMainView()
                    } else {
                        self.dummyCoordinator.showOnboardingView()
                    }
                }
            }
        }.disposed(by: disposeBag)
    }
}
