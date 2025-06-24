//
//  DummyCoordinatorUseCase.swift
//  BestWish
//
//  Created by yimkeul on 6/24/25.
//

import Foundation

protocol DummyCoordinatorUseCase {

    /// 로그인 화면 이동
    func showLoginView()

    /// 온보딩 화면 이동
    func showOnboardingView()

    /// 메인 화면 이동
    func showMainView()
}

final class DummyCoordinatorUseCaseImpl: DummyCoordinatorUseCase {
    private let repository: DummyCoordinatorRepository

    init(repository: DummyCoordinatorRepository) {
        self.repository = repository
    }

    /// 로그인 화면 이동
    func showLoginView() {
        repository.showLoginView()
    }

    /// 온보딩 화면 이동
    func showOnboardingView() {
        repository.showOnboardingView()
    }

    /// 메인 화면 이동
    func showMainView() {
        repository.showMainView()
    }
}
