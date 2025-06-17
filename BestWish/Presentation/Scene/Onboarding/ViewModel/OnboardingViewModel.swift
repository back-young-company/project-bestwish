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

    enum Action {
        case viewDidAppear
        case selectedProfileIndex(Int)
        case selectedGender(Gender)
        case selectedBirth(Date)
        case inputNicknameValid(Bool)
        case inputNickname(String)
        case nextPage
        case prevPage
        case uploadUserInfo(UserInfoDisplay)
    }

    struct State {
        let userInfo: Observable<UserInfoDisplay>
        let isValidNickname: Observable<Bool>
        let currentPage: Observable<Int>
        let showPolicySheet: Observable<Void>
    }

    private let _action = PublishSubject<Action>()
    var action: AnyObserver<Action> { _action.asObserver() }

    private let _userInput = BehaviorRelay<UserInfoDisplay> (value:
        UserInfoDisplay(
        profileImageCode: 0)
    )

    private let _currentPage = BehaviorRelay<Int> (value: OnboardingViewModel.onboardingStartPage)

    private let _isValidNickname = BehaviorRelay<Bool>(value: false)
    private let _showPolicySheet = PublishRelay<Void>()

    let state: State

    init(useCase: UserInfoUseCase) {
        self.useCase = useCase

        let showPolicy = _action
            .filter { action in
            if case .viewDidAppear = action { return true }
            return false
        }
            .withLatestFrom(_currentPage.asObservable())
            .filter { $0 == Self.onboardingStartPage }
            .take(1)
            .map { _ in () }

        // bindAction() 에서 이 이벤트를 Relay로 다시 전달
        showPolicy
            .bind(to: _showPolicySheet)
            .disposed(by: disposeBag)

        state = State(
            userInfo: _userInput.asObservable(),
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
                break
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
            case .inputNicknameValid(let valid):
                owner._isValidNickname.accept(valid)

            case .uploadUserInfo(let userInfo):
                Task {
                    await self.updateUserInfo(with: userInfo)
                    // TODO: MainView로 화면전환
                    SampleViewChangeManager.shared.goMainView()
                }
            }
        }.disposed(by: disposeBag)
    }

    private func updateUserInfo(with index: UserInfoDisplay) async {
        do {
            try await self.useCase.updateUserInfo(
                profileImageCode: index.profileImageCode,
                nickname: index.nickname,
                gender: index.gender,
                birth: index.birth)
        } catch {
            print(error.localizedDescription)
        }
    }

    private func updateGender(with index: Gender) {
        var userInput = _userInput.value
        userInput.updateGender(to: index.rawValue)
        _userInput.accept(userInput)
    }

    private func updateBirth(with index: Date) {
        var userInput = _userInput.value
        userInput.updateBirth(to: index)
        _userInput.accept(userInput)
    }

    private func updateProfileImage(with index: Int) {
        var userInput = _userInput.value
        userInput.updateprofileImageCode(to: index)
        _userInput.accept(userInput)
    }

    private func updateNickname(with index: String) {
        var userInput = _userInput.value
        userInput.updateNickname(to: index)
        _userInput.accept(userInput)
    }
}
