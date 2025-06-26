//
//  DIContainer.swift
//  BestWish
//
//  Created by 이수현 on 6/5/25.
//

import Foundation

/// 의존성 주입 컨테이너
final class DIContainer {

    static let shared = DIContainer()

    private let supabaseManager: SupabaseManager
    private let supabaseUserInfoManager: SupabaseUserInfoManager
    private let supabaseOAuthManager: SupabaseOAuthManager
    private let keyChainManager: KeyChainManager
    private let productSyncManager: ProductSyncManager
    private let coreMLManager: CoreMLManager

    private let accountRepository: AccountRepository
    private let userInfoRepository: UserInfoRepository
    private let coreMLRepository: CoreMLRepository
    private let productSyncRepository: ProductSyncRepository
    private let wishListRepository: WishListRepository

    private let accountUseCase: AccountUseCase
    private let userInfoUseCase: UserInfoUseCase
    private let coreMLUseCase: CoreMLUseCase
    private let analysisUseCase: AnalysisUseCase
    private let productSyncUseCase: ProductSyncUseCase
    private let wishListUseCase: WishListUseCase

    private init() {
        self.supabaseManager = SupabaseManager()
        self.supabaseUserInfoManager = SupabaseUserInfoManagerImpl()
        self.supabaseOAuthManager = SupabaseOAuthManager()
        self.keyChainManager = KeyChainManager()
        self.productSyncManager = ProductSyncManager()
        self.coreMLManager = CoreMLManager()

        self.accountRepository = AccountRepositoryImpl(
            manager: supabaseOAuthManager,
            keyChain: keyChainManager
        )
        self.userInfoRepository = UserInfoRepositoryImpl(manager: supabaseUserInfoManager)
        self.coreMLRepository = CoreMLRepositoryImpl(manager: coreMLManager)
        self.productSyncRepository = ProductSyncRepositoryImpl(manager: productSyncManager)
        self.wishListRepository = WishListRepositoryImpl(
            manager: supabaseManager,
            userInfoManager: supabaseUserInfoManager
        )

        self.accountUseCase = AccountUseCaseImpl(repository: accountRepository)
        self.userInfoUseCase = UserInfoUseCaseImpl(repository: userInfoRepository)
        self.coreMLUseCase = CoreMLUserCaseImpl(repository: coreMLRepository)
        self.analysisUseCase = AnalysisUseCaseImpl()
        self.productSyncUseCase = ProductSyncUseCaseImpl(repository: productSyncRepository)
        self.wishListUseCase = WishListUseCaseImpl(repository: wishListRepository)
    }

    func makeAccountRepository() -> AccountRepository {
        return AccountRepositoryImpl(
            manager: supabaseOAuthManager,
            keyChain: keyChainManager
        )
    }

    /// 홈 뷰 컨트롤러 생성
    func makeHomeViewController() -> HomeViewController {
        let viewModel = HomeViewModel(useCase: wishListUseCase)
        return HomeViewController(homeViewModel: viewModel)
    }

    /// 플랫폼 편집 뷰 컨트롤러 생성
    func makePlatformEditViewController() -> PlatformEditViewController {
        let viewModel = PlatformEditViewModel(useCase: wishListUseCase)
        return PlatformEditViewController(platformEditViewModel: viewModel)
    }

    /// 위시리스트 편집 뷰 컨트롤러 생성
    func makeWishlistEditViewController() -> WishListEditViewController {
        let viewModel = WishListEditViewModel(useCase: wishListUseCase)
        return WishListEditViewController(wishEditViewModel: viewModel)
    }

    /// 링크 저장 뷰 컨트롤러 생성
    func makeLinkSaveViewController() -> LinkSaveViewController {
        let viewModel = LinkSaveViewModel(
            wishListUseCase: wishListUseCase,
            productSyncUseCase: productSyncUseCase
        )
        return LinkSaveViewController(viewModel: viewModel)
    }

    /// 마이페이지 뷰 컨트롤러 생성
    func makeMyPageViewController() -> MyPageViewController {
        let viewModel = MyPageViewModel(
            userInfoUseCase: userInfoUseCase,
            accountUseCase: accountUseCase
        )
        return MyPageViewController(viewModel: viewModel)
    }

    /// 프로필 업데이트 뷰 컨트롤러 생성
    func makeProfileUpdateViewController() -> ProfileUpdateViewController {
        let viewModel = ProfileUpdateViewModel(useCase: userInfoUseCase)
        return ProfileUpdateViewController(viewModel: viewModel)
    }

    /// 유저 정보 업데이트 뷰 컨트롤러 생성
    func makeUserInfoUpdateViewController() -> UserInfoUpdateViewController {
        let viewModel = UserInfoUpdateViewModel(useCase: userInfoUseCase)
        return UserInfoUpdateViewController(viewModel: viewModel)
    }

    /// 유저 정보 관리 뷰 컨트롤러 생성
    func makeUserInfoManagementViewController() -> UserInfoManagementViewController {
        let viewModel = UserInfoManagementViewModel(
            userInfoUseCase: userInfoUseCase,
            accountUseCase: accountUseCase
        )
        return UserInfoManagementViewController(viewModel: viewModel)
    }

    func makeLoginViewController() -> LoginViewController {
        let viewModel = LoginViewModel(useCase: accountUseCase)
        return LoginViewController(viewModel: viewModel)
    }

    func makeOnboardingViewController() -> OnboardingViewController {
        let onboardingViewModel = OnboardingViewModel(useCase: userInfoUseCase)
        let policyViewModel = PolicyViewModel()
        return OnboardingViewController(
            viewModel: onboardingViewModel,
            policyViewModel: policyViewModel
        )
    }

    /// 카메라 뷰 컨트롤러 생성
    func makeCameraViewController() -> CameraViewController {
        return CameraViewController()
    }

    /// 이미지 편집 뷰 컨트롤러 생성
    func makeImageEditController(imageData: Data) -> ImageEditViewController {
        let viewModel = ImageEditViewModel(coreMLUseCase: coreMLUseCase)
        return ImageEditViewController(imageData: imageData, viewModel: viewModel)
    }

    /// 이미지 분석 뷰 컨트롤러 생성
    func makeAnalysisViewController(labelData: [LabelDataEntity]) -> AnalaysisViewController {
        let viewModel = AnalysisViewModel(analysisUseCase: analysisUseCase, labelData: labelData)
        return AnalaysisViewController(viewModel: viewModel)
    }
}
