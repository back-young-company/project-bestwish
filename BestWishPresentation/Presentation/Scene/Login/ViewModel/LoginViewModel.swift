//
//  LoginViewModel.swift
//  BestWish
//
//  Created by yimkeul on 6/7/25.
//

import BestWishDomain

internal import RxRelay
internal import RxSwift

/// 로그인 View Model
public final class LoginViewModel: ViewModel {

    // MARK: - Action
    enum Action {
        case logInKakao
        case logInApple
    }

    // MARK: - State
    struct State {
        let readyToUseService: Observable<Bool>
        let error: Observable<AppError>
    }

    // MARK: - Internal Property
    var action: AnyObserver<Action> { _action.asObserver() }
    let state: State

    // MARK: - Private Property
    private let _action = PublishSubject<Action>()

    private let _readyToUseService = PublishRelay<Bool>()
    private let _error = PublishSubject<AppError>()

    private let useCase: AccountUseCase
    private let disposeBag = DisposeBag()

    public init(useCase: AccountUseCase) {
        self.useCase = useCase
        state = State(
            readyToUseService: _readyToUseService.asObservable(),
            error: _error.asObservable()
        )
        bindAction()
    }

    private func bindAction() {
        _action.subscribe(with: self) { owner, action in
            switch action {
            case .logInKakao, .logInApple:
                Task {
                    do {
                        let type: SocialType = (action == .logInKakao) ? .kakao : .apple
                        try await owner.useCase.login(type: type)

                        let didSignIn = try await owner.useCase.checkSignInState()
                        owner._readyToUseService.accept(didSignIn)
                    } catch {
                        self.handleError(error)
                    }
                }
            }
        }.disposed(by: disposeBag)
    }

    /// 에러 핸들링
    private func handleError(_ error: Error) {
        if let error = error as? AppError {
            _error.onNext(error)
        } else {
            _error.onNext(AppError.unknown(error))
        }
    }
}
