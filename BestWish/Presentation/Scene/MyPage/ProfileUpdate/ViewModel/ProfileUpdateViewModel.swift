//
//  ProfileUpdateViewModel.swift
//  BestWish
//
//  Created by 이수현 on 6/10/25.
//

import RxRelay
import RxSwift

/// 프로필 업데이트 View Model
final class ProfileUpdateViewModel: ViewModel {

    // MARK: - Action
    enum Action {
        case getUserInfo
        case updateProfileImageCode(Int)
        case updateNickname(String)
        case saveUserInfo
    }

    // MARK: - State
    struct State {
        let userInfo: Observable<UserInfoModel?>
        let isValidNickname: Observable<Bool>
        let completedSave: Observable<Void>
        let error: Observable<AppError>
    }

    // MARK: - Internal Property
    var action: AnyObserver<Action> { _action.asObserver() }
    let state: State

    // MARK: - Private Property
    private let _action = PublishSubject<Action>()

    private let _userInfo = BehaviorRelay<UserInfoModel?>(value: nil)
    private let _isValidNickname = BehaviorRelay<Bool>(value: true)
    private let _completedSave = PublishSubject<Void>()
    private let _error = PublishSubject<AppError>()

    private let useCase: UserInfoUseCase
    private let disposeBag = DisposeBag()

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
            case let .updateProfileImageCode(index):
                owner.updateProfileImage(with: index)
            case let .updateNickname(nickname):
                owner.updateNickname(to: nickname)
            case .saveUserInfo:
                owner.saveUserInfo()
            }
        }.disposed(by: disposeBag)
    }

    /// 유저 정보 불러오기
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

    /// 프로필 이미지 변경
    private func updateProfileImage(with index: Int) {
        var userInfo = _userInfo.value
        userInfo?.updateprofileImageCode(to: index)
        _userInfo.accept(userInfo)
    }

    /// 닉네임 유효 확인 및  변경
    private func updateNickname(to nickname: String) {
        let isValid = useCase.isValidNickname(nickname)
        _isValidNickname.accept(isValid)

        if isValid {
            var userInfo = _userInfo.value
            userInfo?.updateNickname(to: nickname)
            _userInfo.accept(userInfo)
        }
    }

    /// 유저 정보 저장
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

    /// User Entity -> UserInfoModel 변환
    private func convertUserInfoModel(from user: User) -> UserInfoModel {
        UserInfoModel(
            profileImageCode: user.profileImageCode,
            email: user.email,
            nickname: user.nickname
        )
    }

    /// 에러 핸들링
    private func handleError(_ error: Error) {
        if let error = error as? AppError {
            _error.onNext(error)
        } else {
            _error.onNext(AppError.unknown(error))
        }
    }
}
