//
//  UserInfoUpdateViewModel.swift
//  BestWish
//
//  Created by 이수현 on 6/12/25.
//

import Foundation

import RxRelay
import RxSwift

/// 유저 정보 업데이트 View Model
final class UserInfoUpdateViewModel: ViewModel {

    // MARK: - Action
    enum Action {
        case getUserInfo
        case updateBirth(Date)
        case updateGender(Int)
        case saveUserInfo
    }

    // MARK: - State
    struct State {
        let userInfo: Observable<UserInfoModel?>
        let completedSave: Observable<Void>
        let error: Observable<AppError>
    }

    // MARK: - Internal Property
    var action: AnyObserver<Action> { _action.asObserver() }
    let state: State

    // MARK: - Private Property
    private let _action = PublishSubject<Action>()

    private let _error = PublishSubject<AppError>()
    private let _userInfo = BehaviorRelay<UserInfoModel?>(value: nil)
    private let _completedSave = PublishSubject<Void>()

    private let useCase: UserInfoUseCase
    private let disposeBag = DisposeBag()

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

    /// 생일 업데이트 메서드
    private func updateBirth(_ date: Date) {
        guard var prevInfo = _userInfo.value else { return }
        prevInfo.updateBirth(to: date)
        _userInfo.accept(prevInfo)
    }

    /// 성별 업데이트 메서드
    private func updateGender(_ genderIndex: Int) {
        guard var prevInfo = _userInfo.value else { return }
        prevInfo.updateGender(to: genderIndex)
        _userInfo.accept(prevInfo)
    }

    /// 유저 정보 저장
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

    /// User Entity -> UserInfoModel 변환 메서드
    private func convertUserInfoModel(from user: User) -> UserInfoModel {
        UserInfoModel(
            profileImageCode: user.profileImageCode,
            email: user.email,
            nickname: user.nickname,
            gender: user.gender,
            birth: user.birth
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

// MARK: - 테스트 전용 메서드
#if DEBUG
extension UserInfoUpdateViewModel {
    /// 유저 정보 초기값 설정
    func injectIntialUserInfo(_ user: UserInfoModel) {
        _userInfo.accept(user)
    }
}
#endif
