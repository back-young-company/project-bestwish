//
//  DummyCoordinatorRepository.swift
//  BestWish
//
//  Created by yimkeul on 6/24/25.
//

import Foundation

protocol DummyCoordinatorRepository {
    /// 로그인 화면 이동
    func showLoginView()

    /// 온보딩 화면 이동
    func showOnboardingView()

    /// 메인 화면 이동
    func showMainView()
}
