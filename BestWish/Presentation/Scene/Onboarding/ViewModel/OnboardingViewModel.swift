//
//  OnboardingViewModel.swift
//  BestWish
//
//  Created by yimkeul on 6/9/25.
//

import Foundation
import RxSwift
import RxRelay

final class OnboardingViewModel: ViewModel {

    private let useCase: UserInfoUseCase
    private let disposeBag = DisposeBag()

    // 총 페이지수
    static private let onboardingStartPage = 0
    static private let onboardingFinishPage = 1

    // 한 번만 정책 시트를 띄웠는지 추적하는 플래그
    private var showPolicyFlag = false

    enum Action {
        case viewDidAppear
        case createUserInfo
        case selectedProfileIndex(Int)
        case selectedGender(Gender)
        case selectedBirth(Date)
        case inputNickname(String)
        case nextPage
        case prevPage
        case uploadUserInfo(UserInfoModel)
    }

    struct State {
        let userInfo: Observable<UserInfoModel?>
        let isValidNickname: Observable<Bool?>
        let currentPage: Observable<Int>
        let showPolicySheet: Observable<Void>
    }

    private let _action = PublishSubject<Action>()
    var action: AnyObserver<Action> { _action.asObserver() }

    private let _userInfo = BehaviorRelay<UserInfoModel?> (value: nil)
    private let _currentPage = BehaviorRelay<Int> (value: OnboardingViewModel.onboardingStartPage)
    private let _isValidNickname = BehaviorRelay<Bool?>(value: nil)
    private let _showPolicySheet = PublishRelay<Void>()

    let state: State

    init(useCase: UserInfoUseCase) {
        self.useCase = useCase

        state = State(
            userInfo: _userInfo.asObservable(),
            isValidNickname: _isValidNickname.asObservable(),
            currentPage: _currentPage.asObservable(),
            showPolicySheet: _showPolicySheet.asObservable()
        )

        bindAction()
    }

    private func bindAction() {
        _action.subscribe(with: self) { owner, action in
            switch action {
            case .viewDidAppear:
                owner.updateShowPolicyFlag(with: owner.showPolicyFlag)
            case .createUserInfo:
                let userInfo = owner.createUserInfoModel()
                self._userInfo.accept(userInfo)
            case .selectedProfileIndex(let index):
                owner.updateProfileImage(with: index)
            case .selectedGender(let gender):
                owner.updateGender(with: gender)
            case .selectedBirth(let date):
                owner.updateBirth(with: date)
            case .nextPage:
                let next = min(self._currentPage.value + 1, OnboardingViewModel.onboardingFinishPage)
                self._currentPage.accept(next)
            case .prevPage:
                let prev = max(self._currentPage.value - 1, OnboardingViewModel.onboardingStartPage)
                self._currentPage.accept(prev)
            case .inputNickname(let nickname):
                owner.updateNickname(with: nickname)
            case .uploadUserInfo(let userInfo):
                Task {
                    await self.updateUserInfo(with: userInfo)
                    // TODO: MainView로 화면전환
                    SampleViewChangeManager.shared.goMainView()
                }
            }
        }.disposed(by: disposeBag)
    }

    private func updateShowPolicyFlag(with flag: Bool) {
        if !flag, self._currentPage.value == Self.onboardingStartPage {
            showPolicyFlag = !flag
            _showPolicySheet.accept(())
        }
    }

    private func createUserInfoModel() -> UserInfoModel {
        return UserInfoModel(profileImageCode: 0)
    }

    private func updateUserInfo(with userInfo: UserInfoModel) async {
        do {
            try await self.useCase.updateUserInfo(
                profileImageCode: userInfo.profileImageCode,
                nickname: userInfo.nickname,
                gender: userInfo.gender,
                birth: userInfo.birth)
        } catch {
            print(error.localizedDescription)
        }
    }

    private func updateGender(with gender: Gender) {
        var userInfo = _userInfo.value
        userInfo?.updateGender(to: gender.rawValue)
        _userInfo.accept(userInfo)
    }

    private func updateBirth(with date: Date) {
        var userInfo = _userInfo.value
        userInfo?.updateBirth(to: date)
        _userInfo.accept(userInfo)
    }

    private func updateProfileImage(with index: Int) {
        var userInfo = _userInfo.value
        userInfo?.updateprofileImageCode(to: index)
        _userInfo.accept(userInfo)
    }

    private func updateNickname(with nickname: String) {
        let isValid = useCase.isValidNickname(nickname)
        _isValidNickname.accept(isValid)

        if isValid {
            var userInfo = _userInfo.value
            userInfo?.updateNickname(to: nickname)
            _userInfo.accept(userInfo)
        }
    }
}
