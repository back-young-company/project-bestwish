//
//  DIContainer.swift
//  BestWish
//
//  Created by 이수현 on 6/5/25.
//

import BestWishData
import BestWishDomain
import BestWishPresentation

import Foundation

/// 의존성 주입 컨테이너
final class DIContainer {

    private let userDefaultsManager: UserDefaultsManager
    private let supabaseManager: SupabaseManager
    private let supabaseUserInfoManager: SupabaseUserInfoManager
    private let supabaseOAuthManager: SupabaseOAuthManager
    private let keyChainManager: KeyChainManager
    private let productSyncManager: ProductSyncManager
    private let coreMLManager: CoreMLManager
    private let firebaseAnalyticsManager: FirebaseAnalyticsManager

    private let userDefaultsRepository: UserDefaultsRepository
    private let accountRepository: AccountRepository
    private let userInfoRepository: UserInfoRepository
    private let coreMLRepository: CoreMLRepository
    private let productSyncRepository: ProductSyncRepository
    private let wishListRepository: WishListRepository

    private let userDefaultsUseCase: UserDefaultsUseCase
    private let accountUseCase: AccountUseCase
    private let userInfoUseCase: UserInfoUseCase
    private let coreMLUseCase: CoreMLUseCase
    private let analysisUseCase: AnalysisUseCase
    private let productSyncUseCase: ProductSyncUseCase
    private let wishListUseCase: WishListUseCase

    init() {
        self.userDefaultsManager = UserDefaultsManager(suiteName: "group.com.bycompany.bestwish")
        self.supabaseManager = SupabaseManager()
        self.supabaseUserInfoManager = SupabaseUserInfoManagerImpl()
        self.supabaseOAuthManager = SupabaseOAuthManagerImpl()
        self.keyChainManager = KeyChainManagerImpl()
        self.productSyncManager = ProductSyncManager()
        self.coreMLManager = CoreMLManager()
        self.firebaseAnalyticsManager = FirebaseAnalyticsManagerImpl()

        self.userDefaultsRepository = UserDefaultsRepositoryImpl(manager: userDefaultsManager)
        self.accountRepository = AccountRepositoryImpl(
            manager: supabaseOAuthManager,
            keyChain: keyChainManager
        )
        self.userInfoRepository = UserInfoRepositoryImpl(manager: supabaseUserInfoManager)
        self.coreMLRepository = CoreMLRepositoryImpl(manager: coreMLManager)
        self.productSyncRepository = ProductSyncRepositoryImpl(manager: productSyncManager, firebaseAnalyticsManager: firebaseAnalyticsManager)
        self.wishListRepository = WishListRepositoryImpl(
            manager: supabaseManager,
            userInfoManager: supabaseUserInfoManager
        )

        self.userDefaultsUseCase = UserDefaultsUseCaseImpl(repository: userDefaultsRepository)
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

    /// 온보딩 뷰 컨트롤러 생성
    func makeOnboardingViewController() -> OnboardingViewController {
        let viewModel = OnboardingViewModel()
        return OnboardingViewController(viewModel: viewModel)
    }

    /// 홈 뷰 컨트롤러 생성
    func makeHomeViewController() -> HomeViewController {
        let viewModel = HomeViewModel(
            wishListUseCase: wishListUseCase,
            userDefaultsUseCase: userDefaultsUseCase
        )
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

    /// 상품 추가 뷰 컨트롤러 생성
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

    func makeSignInViewController() -> SignInViewController {
        let signInViewModel = SignInViewModel(useCase: userInfoUseCase)
        let policyViewModel = PolicyViewModel()
        return SignInViewController(
            viewModel: signInViewModel,
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
