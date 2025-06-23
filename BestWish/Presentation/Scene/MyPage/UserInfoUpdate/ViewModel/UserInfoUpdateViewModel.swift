//
//  UserInfoUpdateViewModel.swift
//  BestWish
//
//  Created by 이수현 on 6/12/25.
//

import Foundation

import RxRelay
import RxSwift

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
        let userInfo: Observable<UserInfoModel?>
        let completedSave: Observable<Void>
        let error: Observable<AppError>
    }

    private let _action = PublishSubject<Action>()
    var action: AnyObserver<Action> { _action.asObserver() }

    private let _error = PublishSubject<AppError>()
    private let _userInfo = BehaviorRelay<UserInfoModel?>(value: nil)
    private let _completedSave = PublishSubject<Void>()
    let state: State

    init(useCase: UserInfoUseCase) {
        self.useCase = useCase
        state = State(
            userInfo: _userInfo.asObservable(),
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
            case let .updateBirth(date):
                owner.updateBirth(date)
            case let .updateGender(genderIndex):
                owner.updateGender(genderIndex)
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
                handleError(error)
            }
        }
    }

    private func convertUserInfoModel(from user: User) -> UserInfoModel {
        UserInfoModel(
            profileImageCode: user.profileImageCode,
            email: user.email,
            nickname: user.nickname,
            gender: user.gender,
            birth: user.birth
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

