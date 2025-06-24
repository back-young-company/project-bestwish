//
//  DummyCoordinatorRepositoryImpl.swift
//  BestWish
//
//  Created by yimkeul on 6/24/25.
//

import Foundation

final class DummyCoordinatorRepositoryImpl: DummyCoordinatorRepository {
    private let dummyCoordinator: DummyCoordinator

    init(dummyCoordinator: DummyCoordinator) {
        self.dummyCoordinator = dummyCoordinator
    }

    /// 로그인 화면 이동
    func showLoginView() {
        dummyCoordinator.showLoginView()
    }

    /// 온보딩 화면 이동
    func showOnboardingView() {
        dummyCoordinator.showOnboardingView()
    }

    /// 메인 화면 이동
    func showMainView() {
        dummyCoordinator.showMainView()
    }
}
