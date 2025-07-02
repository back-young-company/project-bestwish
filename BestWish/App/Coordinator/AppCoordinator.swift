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
        self.diContainer = DIContainer() // 기존 싱글턴 DIContainer 사용
        navigationController.setNavigationBarHidden(true, animated: false)
        window.rootViewController = navigationController // 초기 루트 뷰 컨트롤러 설정
        window.backgroundColor = .gray0
    }

    /// 앱의 시작점
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
        let repo = diContainer.makeAccountRepository()

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

    /// 로그인 뷰 띄우기
    func showLoginView() {
        // DIContainer를 통해 ViewModel 생성
        let loginViewController = diContainer.makeLoginViewController()
        loginViewController.flowDelegate = self
        navigationController.setViewControllers([loginViewController], animated: false) // 첫 화면으로 설정
    }

    /// 회원가입 뷰 띄우기
    func showSignInView() {
        let signInViewController = diContainer.makeSignInViewController()
        signInViewController.flowDelegate = self
        navigationController.setViewControllers([signInViewController], animated: true)
    }

    /// 메인 뷰 띄우기
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

    /// 온보딩 뷰 띄우기
    func showOnboardingView() {
        let vc = diContainer.makeOnboardingViewController()
        navigationController.present(vc, animated: true)
    }

    // MARK: - 홈 관련 뷰

    /// 위시리스트 편집 뷰 띄우기
    func showWishListEditView(_ delegate: HomeViewControllerUpdate) {
        let vc = diContainer.makeWishlistEditViewController()
        vc.delegate = delegate
        homeNavigation?.pushViewController(vc, animated: true)
    }

    /// 링크 저장 얼럿 뷰 띄우기
    func showLinkSaveAlertView(_ delegate: HomeViewControllerUpdate) {
        let alertVC = diContainer.makeLinkSaveViewController()
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        alertVC.delegate = delegate

        homeNavigation?.present(alertVC, animated: true)
    }

    /// 플랫폼 편집 뷰 띄우기
    func showPlatformEditView(_ delegate: HomeViewControllerUpdate) {
        let vc = diContainer.makePlatformEditViewController()
        vc.delegate = delegate
        homeNavigation?.pushViewController(vc, animated: true)
    }

    // MARK: - 카메라 관련 뷰

    /// 이미지 편집 뷰 띄우기
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

    /// 이미지 분석 뷰 띄우기
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

    // MARK: - 마이페이지 관련 뷰

    /// 유저 정보 관리 뷰 띄우기
    func showUserInfoManagementView() {
        let vc = diContainer.makeUserInfoManagementViewController()
        vc.flowDelegate = self
        myPageNavigation?.pushViewController(vc, animated: true)
    }

    /// 프로필 업데이트 뷰 띄우기
    func showProfileUpdateView() {
        let vc = diContainer.makeProfileUpdateViewController()
        myPageNavigation?.pushViewController(vc, animated: true)
    }

    /// 유저 정보 업데이트 뷰 띄우기
    func showUserInfoUpdateView() {
        let vc = diContainer.makeUserInfoUpdateViewController()
        myPageNavigation?.pushViewController(vc, animated: true)
    }
}

// MARK: - LoginFlowDelegate
extension AppCoordinator: LoginFlowDelegate {
    /// oauth & 회원가입 결과에 따른 화면 이동
    func readyToUseService(state: Bool) {
        if state {
            showMainView()
        } else {
            showSignInView()
        }
    }
}

// MARK: - SignInFlowDelegate
extension AppCoordinator: SignInFlowDelegate {
    /// 회원가입 결과에 따른 화면 이동
    func readyToUse() {
        showMainView()
    }
}

// MARK: - HomeFlowDelegate
extension AppCoordinator: HomeFlowDelegate {
    /// 플랫폼 편집 버튼 탭
    func didTapPlatformEditButton(_ delegate: HomeViewControllerUpdate) {
        showPlatformEditView(delegate)
    }

    /// 링크 저장 버튼 탭
    func didTapLinkButton(_ delegate: HomeViewControllerUpdate) {
        showLinkSaveAlertView(delegate)
    }

    /// 위시 리스트 편집 버튼 탭
    func didTapWishListEditButton(_ delegate:HomeViewControllerUpdate) {
        showWishListEditView(delegate)
    }

    /// 온보딩 설정
    func setOnboarding() {
        showOnboardingView()
    }
}

// MARK: - CameraFlowDelegate
extension AppCoordinator: CameraFlowDelegate {
    /// 이미지 크로퍼 뷰 present
    func presentImageCropper(
        imageData: Data,
        session: AVCaptureSession?,
        queue: DispatchQueue
    ) {
        showImageCropperView(imageData: imageData, session: session, queue: queue)
    }
}

// MARK: - ImageEditFlowDelegate
extension AppCoordinator: ImageEditFlowDelegate {
    /// 뒤로가기 버튼 터치
    func didTapCancelButton() {
        cameraNavigation?.viewControllers.last?.dismiss(animated: false)
    }

    /// 라벨데이터 요청 완료
    func didSetLabelData(labelData: [LabelDataEntity]) {
        showAnalysisView(labelData:labelData)
    }
}

// MARK: - MyPageFlowDelegate
extension AppCoordinator: MyPageFlowDelegate {
    /// 유저 정보 관리 뷰 탭
    func didTapUserInfoManagementCell() {
        showUserInfoManagementView()
    }

    /// 서비스 가이드 셀 탭
    func didTapOnboardingCell() {
        showOnboardingView()
    }

    /// 프로필 업데이트 셀 탭
    func didTapProflieUpateCell() {
        showProfileUpdateView()
    }

    /// 로그아웃 셀 탭
    func didTapLogout() {
        showLoginView()
    }

    /// 유저 정보 변경 셀 탭
    func didTapUserInfoUpdateCell() {
        showUserInfoUpdateView()
    }

    /// 회원탈퇴 탭
    func didTapWithdraw() {
        showLoginView()
    }
}
