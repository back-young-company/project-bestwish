//
//  AppCoordinator.swift
//  BestWish
//
//  Created by 이수현 on 7/2/25.
//

import AVFoundation
import BestWishData
import BestWishDomain
import BestWishPresentation
import UIKit

final class AppCoordinator {
    private let window: UIWindow
    private let navigationController: UINavigationController // 앱의 주 Navigation 스택 관리
    private let diContainer: DIContainer // DIContainer는 여기서 참조하여 사용

    private var homeNavigation: UINavigationController?
    private var cameraNavigation: UINavigationController?
    private var myPageNavigation: UINavigationController?

    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        self.diContainer = DIContainer.shared // 기존 싱글턴 DIContainer 사용
        navigationController.setNavigationBarHidden(true, animated: false)
//        navigationController.navigationBar.isHidden = true
        window.rootViewController = navigationController // 초기 루트 뷰 컨트롤러 설정
        window.backgroundColor = .gray0
    }

    func start() {

        // LaunchScreen.storyboard에서 Splash 뷰 로드
        let launchStoryboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
        guard let splashVC = launchStoryboard.instantiateInitialViewController(),
            let splashView = splashVC.view else {
            fatalError("LaunchScreen.storyboard initial VC 또는 view를 찾을 수 없습니다.")
        }
        splashView.frame = window.bounds
        splashView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        window.addSubview(splashView)

        // TODO: - 수정하기 (with DIContainer)
        let repo = DIContainer.shared.makeAccountRepository()

        // 초기화 로직 수행 후 화면 전환
        Task {
            let isAlive = await repo.checkSupabaseSession()

            if isAlive {
                do {
                    let didSignIn = try await repo.checkSignInState()
                    await MainActor.run {
                        splashView.removeFromSuperview()
                        if didSignIn {
                            self.showMainView()
                        } else {
                            self.showSignInView()
                        }
                    }
                } catch {
                    await MainActor.run {
                        splashView.removeFromSuperview()
                        self.showLoginView()
                    }
                }
            } else {
                await MainActor.run {
                    splashView.removeFromSuperview()
                    self.showLoginView()
                }
            }
        }
    }

    // MARK: - Flow Methods (Coordinator가 화면을 생성하고 전환하는 역할)

    func showLoginView() {
        // DIContainer를 통해 ViewModel 생성
        let loginViewController = diContainer.makeLoginViewController()
        loginViewController.flowDelegate = self
        navigationController.setViewControllers([loginViewController], animated: false) // 첫 화면으로 설정
    }

    func showSignInView() {
        let signInViewController = diContainer.makeSignInViewController()
        signInViewController.flowDelegate = self
        navigationController.setViewControllers([signInViewController], animated: true)
    }

    func showMainView() {
        let homeVC = diContainer.makeHomeViewController()
        homeVC.flowDelegate = self
        homeNavigation = UINavigationController(rootViewController: homeVC)

        let cameraVC = diContainer.makeCameraViewController()
        cameraVC.flowDelegate = self
        cameraNavigation = UINavigationController(rootViewController: cameraVC)

        let myPageVC = diContainer.makeMyPageViewController()
        myPageVC.flowDelegate = self
        myPageNavigation = UINavigationController(rootViewController: myPageVC)


        guard let homeNavigation, let cameraNavigation, let myPageNavigation else { return }
        let tabBar = TabBarViewController(
            viewControllers: [
                homeNavigation,
                cameraNavigation,
                myPageNavigation
            ]
        )

        navigationController.setViewControllers([tabBar], animated: true)
    }

    func showOnboardingView() {
        let vc = diContainer.makeOnboardingViewController()
        navigationController.present(vc, animated: true)
    }

    func showWishListEditView(_ delegate: HomeViewControllerUpdate) {
        let vc = diContainer.makeWishlistEditViewController()
        vc.delegate = delegate
        homeNavigation?.pushViewController(vc, animated: true)
    }

    func showLinkSaveAlertView(_ delegate: HomeViewControllerUpdate) {
        let alertVC = diContainer.makeLinkSaveViewController()
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        alertVC.delegate = delegate

        homeNavigation?.present(alertVC, animated: true)
    }

    func showPlatformEditView(_ delegate: HomeViewControllerUpdate) {
        let vc = diContainer.makePlatformEditViewController()
        vc.delegate = delegate
        homeNavigation?.pushViewController(vc, animated: true)
    }

    func showImageCropperView(
        imageData: Data,
        session: AVCaptureSession?,
        queue: DispatchQueue
    )  {
        let imageEditVC = diContainer.makeImageEditController(imageData: imageData)
        imageEditVC.flowDelegate = self
        imageEditVC.onDismiss = {
            queue.async {
                session?.startRunning()
            }
        }

        let navVC = UINavigationController(rootViewController: imageEditVC)
        navVC.modalPresentationStyle = .fullScreen
        cameraNavigation?.present(navVC, animated: false)
    }

    func showAnalysisView(labelData: [LabelDataEntity]) {
        let vc = diContainer.makeAnalysisViewController(labelData: labelData)
        vc.modalPresentationStyle = .pageSheet

        if let sheet = vc.sheetPresentationController {
            sheet.detents = [
                .medium(),
                .custom(identifier: .init("mini")) { context in
                    return context.maximumDetentValue * 0.22
                }
            ]
            sheet.selectedDetentIdentifier = .medium
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }

        cameraNavigation?.viewControllers.last?.present(vc, animated: false)
    }

    func showUserInfoManagementView() {
        let vc = diContainer.makeUserInfoManagementViewController()
        vc.flowDelegate = self
        myPageNavigation?.pushViewController(vc, animated: true)
    }

    func showProfileUpdateView() {
        let vc = diContainer.makeProfileUpdateViewController()
        myPageNavigation?.pushViewController(vc, animated: true)
    }

    func showUserInfoUpdateView() {
        let vc = diContainer.makeUserInfoUpdateViewController()
        myPageNavigation?.pushViewController(vc, animated: true)
    }
}


extension AppCoordinator: LoginFlowDelegate {
    func readyToUseService(state: Bool) {
        if state {
            showMainView()
        } else {
            showSignInView()
        }
    }
}

extension AppCoordinator: SignInFlowDelegate {
    /// 회원가입 결과에 따른 화면 이동
    func readyToUse() {
        showMainView()
    }
}

extension AppCoordinator: HomeFlowDelegate {
    func didTapPlatformEditButton(_ delegate: HomeViewControllerUpdate) {
        showPlatformEditView(delegate)
    }
    
    func didTapLinkButton(_ delegate: HomeViewControllerUpdate) {
        showLinkSaveAlertView(delegate)
    }
    
    func didTapWishListEditButton(_ delegate:HomeViewControllerUpdate) {
        showWishListEditView(delegate)
    }
    
    func setOnboarding() {
        showOnboardingView()
    }
}

extension AppCoordinator: CameraFlowDelegate {
    func presentImageCropper(
        imageData: Data,
        session: AVCaptureSession?,
        queue: DispatchQueue
    ) {
        showImageCropperView(imageData: imageData, session: session, queue: queue)
    }
}

extension AppCoordinator: ImageEditFlowDelegate {
    func didTapCancelButton() {
        navigationController.dismiss(animated: false)
    }
    
    func didSetLabelData(labelData: [LabelDataEntity]) {
        showAnalysisView(labelData:labelData)
    }
}

extension AppCoordinator: MyPageFlowDelegate {
    func didTapUserInfoManagementCell() {
        showUserInfoManagementView()
    }
    
    func didTapOnboardingCell() {
        showOnboardingView()
    }
    
    func didTapProflieUpateCell() {
        showProfileUpdateView()
    }
    
    func didTapLogout() {
        showLoginView()
    }

    func didTapUserInfoUpdateCell() {
        showUserInfoUpdateView()
    }

    func didTapWithdraw() {
        showLoginView()
    }
}

