//
//  LoginViewModel.swift
//  BestWish
//
//  Created by yimkeul on 6/7/25.
//

import Foundation
import RxSwift

final class LoginViewModel: ViewModel {

    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let supabaseOAuthManager = SupabaseOAuthManager.shared
    // MARK: - Actions
    enum Action {
        case viewDidLoad(Void)
        case signInKakao(Void)
    }

    // MARK: - States
    struct State {
        /// sample
        let data: Observable<DummyDisplay>
        let newData: Observable<DummyDisplay>
        let error: Observable<Error>
    }

    // MARK: - Inputs
    private let _action = PublishSubject<Action>()
    var action: AnyObserver<Action> { _action.asObserver() }

    // MARK: - Outputs
    /// sample
    private let _data = PublishSubject<DummyDisplay>()
    private let _newData = PublishSubject<DummyDisplay>()
    private let _error = PublishSubject<Error>()

    let state: State

    // MARK: - Initializer, Deinit, requiered
    init() {
        state = State(
            data: _data.asObservable(),
            newData: _newData.asObservable(),
            error: _error.asObservable()
        )

        bindAction()
    }

    // MARK: - Bind
    private func bindAction() {
        _action.subscribe(with: self) { owner, action in
            switch action {
            case .viewDidLoad: break
            case .signInKakao:
                SupabaseOAuthManager.shared.signIn(type: .kakao)
                // 화면이동
            }
        }.disposed(by: disposeBag)
    }

    // MARK: Methods

}
