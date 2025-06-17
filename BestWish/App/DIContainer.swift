//
//  DIContainer.swift
//  BestWish
//
//  Created by 이수현 on 6/5/25.
//

import UIKit

final class DIContainer {
    static let shared = DIContainer()

    private let supabaseUserInfoManager: SupabaseUserInfoManager
    private let supabaseOAuthManager: SupabaseOAuthManager
    private let userInfoRepository: UserInfoRepository
    private let accountRepository: AccountRepository
    private let userInfoUseCase: UserInfoUseCase
    private let accountUseCase: AccountUseCase
    private let coreMLRepository: CoreMLRepository
    private let coreMLUseCase: CoreMLUseCase

    private init() {
        self.supabaseUserInfoManager = SupabaseUserInfoManager()
        self.supabaseOAuthManager = SupabaseOAuthManager.shared
        self.userInfoRepository = UserInfoRepositoryImpl(manager: supabaseUserInfoManager)
        self.accountRepository = AccountRepositoryImpl(manager: supabaseOAuthManager)
        self.userInfoUseCase = UserInfoUseCaseImpl(repository: userInfoRepository)
        self.accountUseCase = AccountUseCaseImpl(repository: accountRepository)
        self.coreMLRepository = CoreMLRepositoryImpl()
        self.coreMLUseCase = CoreMLUserCaseImpl(repository: coreMLRepository)
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
}
