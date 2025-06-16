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
        let userInfo: Observable<UserInfoDisplay>
    }

    private let _action = PublishSubject<Action>()
    var action: AnyObserver<Action> { _action.asObserver() }

    private let _userInfo = BehaviorRelay<UserInfoDisplay>(value: UserInfoDisplay(
        profileImageCode: 0,
        email: "user@gmail.com", nickname: "User"
        )
    )

    let state: State

    init() {
        state = State(userInfo: _userInfo.asObservable())

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
        var userInfo = _userInfo.value
        userInfo.updateprofileImageCode(to: index)
        _userInfo.accept(userInfo)
    }
}
