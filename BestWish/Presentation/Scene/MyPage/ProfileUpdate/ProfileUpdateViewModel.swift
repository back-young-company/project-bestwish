//
//  ProfileUpdateViewModel.swift
//  BestWish
//
//  Created by 이수현 on 6/10/25.
//

import RxSwift
import RxRelay

final class ProfileUpdateViewModel: ViewModel {
    private let disposeBag = DisposeBag()

    enum Action {

    }

    struct State {

    }

    private let _action = PublishSubject<Action>()
    var action: AnyObserver<Action> { _action.asObserver() }

    let state: State

    init() {
        state = State()

        bindAction()
    }

    private func bindAction() {

    }
}

