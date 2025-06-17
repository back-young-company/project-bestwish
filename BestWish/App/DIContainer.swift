//
//  DIContainer.swift
//  BestWish
//
//  Created by 이수현 on 6/5/25.
//

import Foundation

final class DIContainer {
    static let shared = DIContainer()
    
    private let supabaseManager: SupabaseManager
    private let supabaseUserInfoManager: SupabaseUserInfoManager
    private let supabaseOAuthManager: SupabaseOAuthManager
    
    private let wishListRepository: WishListRepository
    private let userInfoRepository: UserInfoRepository
    
    private let wishListUseCase: WishListUseCase
    private let userInfoUseCase: UserInfoUseCase

    private init() {
        self.supabaseManager = SupabaseManager()
        self.supabaseUserInfoManager = SupabaseUserInfoManager()
        self.supabaseOAuthManager = SupabaseOAuthManager.shared
        
        self.wishListRepository = WishListRepositoryImpl(manager: supabaseManager, userInfoManager: supabaseUserInfoManager)
        self.userInfoRepository = UserInfoRepositoryImpl(manager: supabaseUserInfoManager)
        
        self.wishListUseCase = WishListUseCaseImpl(repository: wishListRepository)
        self.userInfoUseCase = UserInfoUseCaseImpl(repository: userInfoRepository)
    }
    
    func makeHomeViewController() -> HomeViewController {
        let viewModel = HomeViewModel(useCase: wishListUseCase)
        return HomeViewController(homeViewModel: viewModel)
    }
    
    func makePlatformEditViewController() -> PlatformEditViewController {
        let viewModel = PlatformEditViewModel(useCase: wishListUseCase)
        return PlatformEditViewController(platformEditViewModel: viewModel)
    }
    
    func makeWishlistEditViewController() -> WishlistEditViewController {
        let viewModel = WishEditViewModel(useCase: wishListUseCase)
        return WishlistEditViewController(wishEditViewModel: viewModel)
    }

    func makeMyPageViewController() -> MyPageViewController {
        let viewModel = MyPageViewModel(useCase: userInfoUseCase)
        return MyPageViewController(viewModel: viewModel)
    }

    func makeProfileUpdateViewController() -> ProfileUpdateViewController {
        let viewModel = ProfileUpdateViewModel(useCase: userInfoUseCase)
        return ProfileUpdateViewController(viewModel: viewModel)
    }

    func makeUserInfoUpdateViewController() -> UserInfoUpdateViewController {
        let viewModel = UserInfoUpdateViewModel(useCase: userInfoUseCase)
        return UserInfoUpdateViewController(viewModel: viewModel)
    }

    func makeOnboardingViewController() -> OnboardingViewController {
        let onboardingViewModel = OnboardingViewModel(useCase: userInfoUseCase)
        let policyViewModel = PolicyViewModel()
        return OnboardingViewController(viewModel: onboardingViewModel, policyViewModel: policyViewModel)
    }
}
