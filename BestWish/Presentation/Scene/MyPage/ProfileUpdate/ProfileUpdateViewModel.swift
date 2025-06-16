//
//  ProfileUpdateViewModel.swift
//  BestWish
//
//  Created by 이수현 on 6/10/25.
//

import RxSwift
import RxRelay

// 프로필 업데이트 저장, 프로필 불러오기, 프로필 선택
final class ProfileUpdateViewModel: ViewModel {
    private let disposeBag = DisposeBag()
    private let useCase: UserInfoUseCase

    enum Action {
        case getUserInfo
        case selectedProfileIndex(Int)
        case saveUserInfo(nickname: String)
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
            case .selectedProfileIndex(let index):
                owner.updateProfileImage(with: index)
            case .saveUserInfo(let nickname):
                owner.saveUserInfo(nickname: nickname)
            }
        }.disposed(by: disposeBag)
    }

    private func updateProfileImage(with index: Int) {
        var userInfo = _userInfo.value
        userInfo?.updateprofileImageCode(to: index)
        _userInfo.accept(userInfo)
    }

    private func getUserInfo() {
        Task {
            let user = try await useCase.getUserInfo()
            let userInfoDisplay = convertUserInfoDisplay(from: user)
            _userInfo.accept(userInfoDisplay)
        }
    }

    private func saveUserInfo(nickname: String) {
        Task {
            guard let userInfo = _userInfo.value else { return }
            do {
                try await useCase.updateUserInfo(
                    profileImageCode: userInfo.profileImageCode,
                    nickname: nickname,
                    gender: nil,
                    birth: nil
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
            nickname: user.nickname
        )
    }
}
