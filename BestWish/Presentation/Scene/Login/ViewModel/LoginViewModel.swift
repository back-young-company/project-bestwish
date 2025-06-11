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
    private let supabaseOAuthManager = SupabaseOAuthManager.shared

    // MARK: - Actions
    enum Action {
        case signInKakao
        case signInApple
    }

    // MARK: - States
    struct State { }

    // MARK: - Inputs
    private let _action = PublishSubject<Action>()
    var action: AnyObserver<Action> { _action.asObserver() }

    // MARK: - Outputs
    /// sample
    let state: State

    // MARK: - Initializer, Deinit, requiered
    init() {
        state = State()
        bindAction()
    }

    // MARK: - Bind
    private func bindAction() {
        _action.subscribe(with: self) { owner, action in
            switch action {
            case .signInKakao:
                SupabaseOAuthManager.shared.signIn(type: .kakao)
            case .signInApple:
                SupabaseOAuthManager.shared.signIn(type: .apple)
            }
        }.disposed(by: disposeBag)
    }

    // MARK: Methods

}
