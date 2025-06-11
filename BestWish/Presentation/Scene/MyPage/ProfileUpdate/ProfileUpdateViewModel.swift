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
        case selectedProfileIndex(Int)
    }

    struct State {
        let userAccount: Observable<AccountDisplay>
    }

    private let _action = PublishSubject<Action>()
    var action: AnyObserver<Action> { _action.asObserver() }

    private let _userAccount = BehaviorRelay<AccountDisplay>(value: AccountDisplay(
        profileImageIndex: 0,
        nickname: "User",
        email: "user@gmail.com"
        )
    )

    let state: State

    init() {
        state = State(userAccount: _userAccount.asObservable())

        bindAction()
    }

    private func bindAction() {
        _action.bind(with: self) { owner, action in
            switch action {
            case .selectedProfileIndex(let index):
                owner.updateProfileImage(with: index)
            }
        }.disposed(by: disposeBag)
    }

    private func updateProfileImage(with index: Int) {
        var userAccount = _userAccount.value
        userAccount.updateProfileImageIndex(to: index)
        _userAccount.accept(userAccount)
    }
}
