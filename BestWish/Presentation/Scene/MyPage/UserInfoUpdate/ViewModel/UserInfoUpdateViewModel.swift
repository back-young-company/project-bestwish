//
//  UserInfoUpdateViewModel.swift
//  BestWish
//
//  Created by 이수현 on 6/12/25.
//

import Foundation
import RxSwift
import RxRelay

final class UserInfoUpdateViewModel: ViewModel {
    private let disposeBag = DisposeBag()

    enum Action {
        case updateBirth(Date)
        case updateGender(Int)
        case saveUserInfo
    }

    struct State {
        let userInfo: Observable<OnboardingDisplay>
    }

    private let _action = PublishSubject<Action>()
    var action: AnyObserver<Action> { _action.asObserver() }

    private let _userInfo = BehaviorRelay(value: OnboardingDisplay(
        profileImageIndex: 0,
        nickname: "123",
        gender: 1,
        birth: Date(timeIntervalSince1970: 31536000)
    ))
    let state: State

    init() {
        state = State(
            userInfo: _userInfo.asObservable()
        )

        bindAction()
    }

    private func bindAction() {
        _action.bind(with: self) { owner, action in
            switch action {
            case .updateBirth(let date):
                owner.updateBirth(date)
            case .updateGender(let genderIndex):
                owner.updateGender(genderIndex)
            case .saveUserInfo:
                owner.saveUserInfo()
            }
        }.disposed(by: disposeBag)
    }

    private func updateBirth(_ date: Date) {
        var prevInfo = _userInfo.value
        prevInfo.updateBirth(to: date)
        _userInfo.accept(prevInfo)
    }

    private func updateGender(_ genderIndex: Int) {
        var prevInfo = _userInfo.value
        prevInfo.updateGender(to: genderIndex)
        _userInfo.accept(prevInfo)
    }

    private func saveUserInfo() {
        let userInfo = _userInfo.value
        // Save
        print(userInfo)
    }
}

