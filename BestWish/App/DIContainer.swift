//
//  DIContainer.swift
//  BestWish
//
//  Created by 이수현 on 6/5/25.
//

import Foundation

final class DIContainer {
    static let shared = DIContainer()

    private let supabaseUserInfoManager: SupabaseUserInfoManager
    private let supabaseOAuthManager: SupabaseOAuthManager
    private let userInfoRepository: UserInfoRepository
    private let userInfoUseCase: UserInfoUseCase

    private init() {
        self.supabaseUserInfoManager = SupabaseUserInfoManager()
        self.supabaseOAuthManager = SupabaseOAuthManager.shared
        self.userInfoRepository = UserInfoRepositoryImpl(manager: supabaseUserInfoManager)
        self.userInfoUseCase = UserInfoUseCaseImpl(repository: userInfoRepository)
    }

    func makeMyPageViewController() -> MyPageViewController {
        let viewModel = MyPageViewModel(useCase: userInfoUseCase)
        return MyPageViewController(viewModel: viewModel)
    }

    func makeProfileUpdateViewController() -> ProfileUpdateViewController {
        let viewModel = ProfileUpdateViewModel(useCase: userInfoUseCase)
        return ProfileUpdateViewController(viewModel: viewModel)
    }
}
