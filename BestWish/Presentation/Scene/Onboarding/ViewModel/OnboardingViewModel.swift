//
//  OnboardingViewModel.swift
//  BestWish
//
//  Created by yimkeul on 6/9/25.
//

import Foundation

import RxRelay
import RxSwift

/// 온보딩 View Model
final class OnboardingViewModel: ViewModel {

    // MARK: - Action
    enum Action {
        case viewDidAppear
        case createUserInfo
        case selectedProfileIndex(Int)
        case selectedGender(Gender)
        case selectedBirth(Date)
        case inputNickname(String)
        case didTapNextPage
        case didTapPrevPage
        case uploadUserInfo(UserInfoModel)
    }

    // MARK: - State
    struct State {
        let userInfo: Observable<UserInfoModel?>
        let isValidNickname: Observable<Bool?>
        let currentPage: Observable<Int>
        let showPolicySheet: Observable<Void>
        let readyToUseService: Observable<Void>
        let error: Observable<AppError>
    }

    // MARK: - Internal Property
    var action: AnyObserver<Action> { _action.asObserver() }
    let state: State

    // MARK: - Private Property
    private let _action = PublishSubject<Action>()

    private let _userInfo = BehaviorRelay<UserInfoModel?> (value: nil)
    private let _isValidNickname = BehaviorRelay<Bool?>(value: nil)
    private let _currentPage = BehaviorRelay<Int> (value: 0)
    private let _showPolicySheet = PublishSubject<Void>()
    private let _readyToUseService = PublishRelay<Void>()
    private let _error = PublishSubject<AppError>()

    private let useCase: UserInfoUseCase
    private let disposeBag = DisposeBag()

    init(useCase: UserInfoUseCase) {
        self.useCase = useCase
        state = State(
            userInfo: _userInfo.asObservable(),
            isValidNickname: _isValidNickname.asObservable(),
            currentPage: _currentPage.asObservable(),
            showPolicySheet: _showPolicySheet.asObservable(),
            readyToUseService: _readyToUseService.asObservable(),
            error: _error.asObservable()
        )
        bindAction()
    }

    private func bindAction() {
        _action.subscribe(with: self) { owner, action in
            switch action {
            case .viewDidAppear:
                owner.updateShowPolicyFlag()
            case .createUserInfo:
                let userInfo = owner.createUserInfoModel()
                self._userInfo.accept(userInfo)
            case .selectedProfileIndex(let index):
                owner.updateProfileImage(with: index)
            case .selectedGender(let gender):
                owner.updateGender(with: gender)
            case .selectedBirth(let date):
                owner.updateBirth(with: date)
            case .didTapNextPage:
                let next = min(self._currentPage.value + 1, 1)
                self._currentPage.accept(next)
            case .didTapPrevPage:
                let prev = max(self._currentPage.value - 1, 0)
                self._currentPage.accept(prev)
            case .inputNickname(let nickname):
                owner.updateNickname(with: nickname)
            case .uploadUserInfo(let userInfo):
                Task {
                    await self.updateUserInfo(with: userInfo)
                }
            }
        }.disposed(by: disposeBag)
    }

    /// 이용약관 최초 실행시에만 적용되도록 Flag 변경
    private func updateShowPolicyFlag() {
        _showPolicySheet.onNext(())
        _showPolicySheet.onCompleted()
    }

    /// 신규 유저 정보 생성
    private func createUserInfoModel() -> UserInfoModel {
        return UserInfoModel(profileImageCode: 0)
    }

    /// 유저 정보 갱신
    private func updateUserInfo(with userInfo: UserInfoModel) async {
        do {
            try await self.useCase.updateUserInfo(
                profileImageCode: userInfo.profileImageCode,
                nickname: userInfo.nickname,
                gender: userInfo.gender,
                birth: userInfo.birth)
            _readyToUseService.accept(())
        } catch {
            handleError(error)
        }
    }

    /// 유저 정보 - 성별 갱신
    private func updateGender(with gender: Gender) {
        var userInfo = _userInfo.value
        userInfo?.updateGender(to: gender.rawValue)
        _userInfo.accept(userInfo)
    }

    /// 유저 정보 - 생년월일 갱신
    private func updateBirth(with date: Date) {
        var userInfo = _userInfo.value
        userInfo?.updateBirth(to: date)
        _userInfo.accept(userInfo)
    }

    /// 유저 정보 - 프로필 이미지 갱신
    private func updateProfileImage(with index: Int) {
        var userInfo = _userInfo.value
        userInfo?.updateprofileImageCode(to: index)
        _userInfo.accept(userInfo)
    }

    /// 유저 정보 - 닉네임 갱신
    private func updateNickname(with nickname: String) {
        let isValid = useCase.isValidNickname(nickname)
        _isValidNickname.accept(isValid)

        if isValid {
            var userInfo = _userInfo.value
            userInfo?.updateNickname(to: nickname)
            _userInfo.accept(userInfo)
        }
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
    extension OnboardingViewModel {
        /// 유저 정보 초기값 설정
        func injectIntialUserInfo(_ user: UserInfoModel) {
            _userInfo.accept(user)
        }
    }
#endif
