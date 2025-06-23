//
//  DIContainer.swift
//  BestWish
//
//  Created by 이수현 on 6/5/25.
//

import UIKit

final class DIContainer {
    static let shared = DIContainer()
    
    private let supabaseManager: SupabaseManager
    private let supabaseUserInfoManager: SupabaseUserInfoManager
    private let supabaseOAuthManager: SupabaseOAuthManager
    private let coreMLManager: CoreMLManager
    
    private let wishListRepository: WishListRepository
    private let userInfoRepository: UserInfoRepository
    
    private let wishListUseCase: WishListUseCase
    private let accountRepository: AccountRepository
    private let userInfoUseCase: UserInfoUseCase
    private let accountUseCase: AccountUseCase
    private let coreMLRepository: CoreMLRepository
    private let coreMLUseCase: CoreMLUseCase
    private let analysisUseCase: AnalysisUseCase

    private init() {
        self.supabaseManager = SupabaseManager()
        self.supabaseUserInfoManager = SupabaseUserInfoManager()
        self.supabaseOAuthManager = SupabaseOAuthManager.shared
        
        self.wishListRepository = WishListRepositoryImpl(manager: supabaseManager, userInfoManager: supabaseUserInfoManager)
        self.userInfoRepository = UserInfoRepositoryImpl(manager: supabaseUserInfoManager)
        self.accountRepository = AccountRepositoryImpl(manager: supabaseOAuthManager)
        
        self.wishListUseCase = WishListUseCaseImpl(repository: wishListRepository)
        self.userInfoUseCase = UserInfoUseCaseImpl(repository: userInfoRepository)
        self.accountUseCase = AccountUseCaseImpl(repository: accountRepository)
        self.coreMLManager = CoreMLManager()
        self.coreMLRepository = CoreMLRepositoryImpl(manager: coreMLManager)
        self.coreMLUseCase = CoreMLUserCaseImpl(repository: coreMLRepository)
        self.analysisUseCase = AnalysisUseCaseImpl()
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
    
    func makeLinkSaveViewController() -> LinkSaveViewController {
        let viewModel = LinkSaveViewModel(useCase: wishListUseCase)
        return LinkSaveViewController(viewModel: viewModel)
    }

    func makeMyPageViewController() -> MyPageViewController {
        let viewModel = MyPageViewModel(userInfoUseCase: userInfoUseCase, accountUseCase: accountUseCase)
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

    func makeUserInfoManagementViewController() -> UserInfoManagementViewController {
        let viewModel = UserInfoManagementViewModel(userInfoUseCase: userInfoUseCase, accountUseCase: accountUseCase)
        return UserInfoManagementViewController(viewModel: viewModel)
    }

    func makeOnboardingViewController() -> OnboardingViewController {
        let onboardingViewModel = OnboardingViewModel(useCase: userInfoUseCase)
        let policyViewModel = PolicyViewModel()
        return OnboardingViewController(viewModel: onboardingViewModel, policyViewModel: policyViewModel)
    }
    
    /// 이미지 편집 뷰 컨트롤러 생성
    func makeImageEditController(image: UIImage) -> ImageEditViewController {
        let viewModel = ImageEditViewModel(coreMLUseCase: coreMLUseCase)
        return ImageEditViewController(image: image, viewModel: viewModel)
    }
    
    func makeAnalysisViewController(labelData: [LabelDataDisplay]) -> AnalaysisViewController {
        let viewModel = AnalysisViewModel(analysisUseCase: analysisUseCase, labelData: labelData)
        return AnalaysisViewController(viewModel: viewModel)
    }
}
