//
//  UserInfoManagementViewModel.swift
//  BestWish
//
//  Created by 이수현 on 6/17/25.
//

import Foundation

import RxSwift
import RxRelay

/// 유저 정보 관리 View Model
final class UserInfoManagementViewModel: ViewModel {

    // MARK: - Action
    enum Action {
        case getAuthProvider
        case withdraw
    }

    // MARK: - State
    struct State {
        let authProvider: Observable<String?>
        let error: Observable<AppError>
    }

    // MARK: - Internal Property
    var action: AnyObserver<Action> { _action.asObserver() }
    let state: State

    // MARK: - Private Property
    private let _action = PublishSubject<Action>()

    private let _error = PublishSubject<AppError>()
    private let _authProvider = PublishSubject<String?>()

    private let userInfoUseCase: UserInfoUseCase
    private let accountUseCase: AccountUseCase
    private let disposeBag = DisposeBag()

    init(userInfoUseCase: UserInfoUseCase, accountUseCase: AccountUseCase) {
        self.userInfoUseCase = userInfoUseCase
        self.accountUseCase = accountUseCase
        state = State(
            authProvider: _authProvider.asObservable(),
            error: _error.asObservable()
        )

        bindAction()
    }

    private func bindAction() {
        _action.bind(with: self) { owner, action in
            switch action {
            case .getAuthProvider:
                owner.getAuthProvider()
            case .withdraw:
                owner.withdraw()
            }
        }.disposed(by: disposeBag)
    }

    /// SNS 계정 연동 정보 불러오기
    private func getAuthProvider() {
        Task {
            do {
                let authProvider = try await userInfoUseCase.getUserInfo()
                    .authProvider
                _authProvider.onNext(authProvider)
            } catch {
                handleError(error)
            }
        }
    }

    /// 회원 탈퇴
    private func withdraw() {
        Task {
            do {
                try await accountUseCase.withdraw()
            } catch {
               handleError(error)
            }
        }
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

