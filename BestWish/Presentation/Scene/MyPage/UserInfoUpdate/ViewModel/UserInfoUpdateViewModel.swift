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
    private let useCase: UserInfoUseCase

    enum Action {
        case getUserInfo
        case updateBirth(Date)
        case updateGender(Int)
        case saveUserInfo
    }

    struct State {
        let userInfo: Observable<UserInfoDisplay?>
        let completedSave: Observable<Void>
    }

    private let _action = PublishSubject<Action>()
    var action: AnyObserver<Action> { _action.asObserver() }

    private let _userInfo = BehaviorRelay<UserInfoDisplay?>(value: nil)
    private let _completedSave = PublishSubject<Void>()
    let state: State

    init(useCase: UserInfoUseCase) {
        self.useCase = useCase
        state = State(
            userInfo: _userInfo.asObservable(),
            completedSave: _completedSave.asObservable()
        )

        bindAction()
    }

    private func bindAction() {
        _action.bind(with: self) { owner, action in
            switch action {
            case .getUserInfo:
                owner.getUserInfo()
            case .updateBirth(let date):
                owner.updateBirth(date)
            case .updateGender(let genderIndex):
                owner.updateGender(genderIndex)
            case .saveUserInfo:
                owner.saveUserInfo()
            }
        }.disposed(by: disposeBag)
    }

    private func getUserInfo() {
        Task {
            let user = try await useCase.getUserInfo()
            let userInfoDisplay = convertUserInfoDisplay(from: user)
            _userInfo.accept(userInfoDisplay)
        }
    }

    private func updateBirth(_ date: Date) {
        guard var prevInfo = _userInfo.value else { return }
        prevInfo.updateBirth(to: date)
        _userInfo.accept(prevInfo)
    }

    private func updateGender(_ genderIndex: Int) {
        guard var prevInfo = _userInfo.value else { return }
        prevInfo.updateGender(to: genderIndex)
        _userInfo.accept(prevInfo)
    }

    private func saveUserInfo() {
        Task {
            guard let userInfo = _userInfo.value else { return }
            do {
                try await useCase.updateUserInfo(
                    profileImageCode: nil,
                    nickname: nil,
                    gender: userInfo.gender,
                    birth: userInfo.birth
                )
                _completedSave.onNext(())
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    private func convertUserInfoDisplay(from user: User) -> UserInfoDisplay {
        UserInfoDisplay(
            profileImageCode: user.profileImageCode,
            email: user.email,
            nickname: user.nickname,
            gender: user.gender,
            birth: user.birth
        )
    }
}

