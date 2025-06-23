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
        case updateProfileImageCode(Int)
        case updateNickname(String)
        case saveUserInfo
    }

    struct State {
        let userInfo: Observable<UserInfoModel?>
        let isValidNickname: Observable<Bool>
        let completedSave: Observable<Void>
        let error: Observable<AppError>
    }

    private let _action = PublishSubject<Action>()
    var action: AnyObserver<Action> { _action.asObserver() }

    private let _userInfo = BehaviorRelay<UserInfoModel?>(value: nil)
    private let _isValidNickname = BehaviorRelay<Bool>(value: true)
    private let _completedSave = PublishSubject<Void>()
    private let _error = PublishSubject<AppError>()
    let state: State

    init(useCase: UserInfoUseCase) {
        self.useCase = useCase
        state = State(
            userInfo: _userInfo.asObservable(),
            isValidNickname: _isValidNickname.asObservable(),
            completedSave: _completedSave.asObservable(),
            error: _error.asObservable()
        )

        bindAction()
    }

    private func bindAction() {
        _action.bind(with: self) { owner, action in
            switch action {
            case .getUserInfo:
                owner.getUserInfo()
            case .updateProfileImageCode(let index):
                owner.updateProfileImage(with: index)
            case .updateNickname(let nickname):
                owner.updateNickname(to: nickname)
            case .saveUserInfo:
                owner.saveUserInfo()
            }
        }.disposed(by: disposeBag)
    }

    private func getUserInfo() {
        Task {
            do {
                let user = try await useCase.getUserInfo()
                let UserInfoModel = convertUserInfoModel(from: user)
                _userInfo.accept(UserInfoModel)
            } catch {
                handleError(error)
            }
        }
    }

    private func updateProfileImage(with index: Int) {
        var userInfo = _userInfo.value
        userInfo?.updateprofileImageCode(to: index)
        _userInfo.accept(userInfo)
    }

    private func updateNickname(to nickname: String) {
        let isValid = useCase.isValidNickname(nickname)
        _isValidNickname.accept(isValid)

        if isValid {
            var userInfo = _userInfo.value
            userInfo?.updateNickname(to: nickname)
            _userInfo.accept(userInfo)
        }
    }

    private func saveUserInfo() {
        Task {
            guard let userInfo = _userInfo.value else { return }
            do {
                try await useCase.updateUserInfo(
                    profileImageCode: userInfo.profileImageCode,
                    nickname: userInfo.nickname,
                    gender: nil,
                    birth: nil
                )
                _completedSave.onNext(())
            } catch {
                handleError(error)
            }
        }
    }

    private func convertUserInfoModel(from user: User) -> UserInfoModel {
        UserInfoModel(
            profileImageCode: user.profileImageCode,
            email: user.email,
            nickname: user.nickname
        )
    }

    private func handleError(_ error: Error) {
        if let error = error as? AppError {
            _error.onNext(error)
        } else {
            _error.onNext(AppError.unknown(error))
        }
    }
}
