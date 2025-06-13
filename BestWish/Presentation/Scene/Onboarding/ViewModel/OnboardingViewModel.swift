//
//  OnboardingViewModel.swift
//  BestWish
//
//  Created by yimkeul on 6/9/25.
//

import Foundation
import RxSwift
import RxRelay
// 임시
import UIKit

final class OnboardingViewModel: ViewModel {

    private let dummyUseCase: DummyUseCase
    private let disposeBag = DisposeBag()

    // 총 페이지수
    static private let onboardingStartPage = 0
    static private let onboardingFinishPage = 1

    enum Action {
        case selectedProfileIndex(Int)
        case selectedGender(Gender)
        case selectedBirth(Date)
        case inputNicknameValid(Bool)
        case inputNickname(String)
        case nextPage
        case prevPage
        case uploadOnboarding(Onboarding)
    }

    struct State {
        let userInfo: Observable<OnboardingDisplay>
        let isValidNickname: Observable<Bool>
        let currentPage: Observable<Int>
    }

    private let _action = PublishSubject<Action>()
    var action: AnyObserver<Action> { _action.asObserver() }

    private let _userInput = BehaviorRelay<OnboardingDisplay> (value:
        OnboardingDisplay(
        profileImageIndex: 0)
    )

    private let _currentPage = BehaviorRelay<Int> (value: OnboardingViewModel.onboardingStartPage)

    private let _isValidNickname = BehaviorRelay<Bool>(value: false)

    let state: State

    init(dummyUseCase: DummyUseCase) {
        self.dummyUseCase = dummyUseCase
        state = State(
            userInfo: _userInput.asObservable(),
            isValidNickname: _isValidNickname.asObservable(),
            currentPage: _currentPage.asObservable()
        )
        bindAction()
    }

    private func bindAction() {
        _action.subscribe(with: self) { owner, action in
            switch action {
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

            case .uploadOnboarding(let data):
                let state = SupabaseOAuthManager.shared.uploadUserInfo(to: data)
                if state {
                    // TODO: MainView로 화면전환
                    SampleViewChangeManager.shared.goMainView()
                }

            }
        }.disposed(by: disposeBag)
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
        userInput.updateProfileImageIndex(to: index)
        _userInput.accept(userInput)
    }

    private func updateNickname(with index: String) {
        var userInput = _userInput.value
        userInput.updateNickname(to: index)
        _userInput.accept(userInput)
    }
}
