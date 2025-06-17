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
    private let useCase: AccountUseCase
    private let disposeBag = DisposeBag()

    enum Action {
        case withdraw
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
        _action.bind(with: self) { owner, action in
            switch action {
            case .withdraw:
                owner.withdraw()
            }
        }.disposed(by: disposeBag)
    }

    private func withdraw() {
        Task {
            do {
                try await useCase.withdraw()
            } catch {
                print(error)
            }
        }
    }
}

