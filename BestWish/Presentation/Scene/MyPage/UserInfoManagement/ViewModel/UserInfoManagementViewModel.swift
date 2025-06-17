//
//  UserInfoManagementViewModel.swift
//  BestWish
//
//  Created by 이수현 on 6/17/25.
//

import Foundation

import RxSwift
import RxRelay

final class UserInfoManagementViewModel: ViewModel {
    private let userInfoUseCase: UserInfoUseCase
    private let accountUseCase: AccountUseCase
    private let disposeBag = DisposeBag()

    enum Action {
        case getAuthProvider
        case withdraw
    }

    struct State {
        let authProvider: Observable<String?>
    }

    private let _action = PublishSubject<Action>()
    var action: AnyObserver<Action> { _action.asObserver() }

    private let _authProvider = PublishSubject<String?>()
    let state: State

    init(userInfoUseCase: UserInfoUseCase, accountUseCase: AccountUseCase) {
        self.userInfoUseCase = userInfoUseCase
        self.accountUseCase = accountUseCase
        state = State(authProvider: _authProvider.asObservable())

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

    private func getAuthProvider() {
        Task {
            do {
                let authProvider = try await userInfoUseCase.getUserInfo()
                    .authProvider
                _authProvider.onNext(authProvider)
            } catch {
                print(error)
            }
        }
    }

    private func withdraw() {
        Task {
            do {
                try await accountUseCase.withdraw()
            } catch {
                print(error)
            }
        }
    }
}

