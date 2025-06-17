//
//  SceneDelegate.swift
//  BestWish
//
//  Created by 이수현 on 6/3/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        /// 서비스 이용순서
        /// 1. 소셜 로그인 성공 유무 판단 -> checkLoginState (기기 내의 supabase의 연결할 토큰확인 (키체인으로 저장)
        ///     a. 로그인 성공시 -> checkOnboardingState (supabase public.UserInfo 테이블에서 role 값 확인하기 ( GUEST = 온보딩 실패 / USER = 온보딩 성공)
        ///         i. 온보딩 성공유무 판단
        ///     b. 로그인 실패시
        ///         i. 로그인 재시도
        ///
        /// a. 로그인 성공시
        ///     i. 온보딩 성공시
        ///         1. 홈화면 실행
        ///     ii.온보딩 실패시
        ///         1. 온보딩부터 실행
        ///
        /// Task 구현이 안전하지 않을시 다른 방법 고려 가능
        Task {
            let isLogin = await SupabaseOAuthManager.shared.checkLoginState()
            if isLogin {
                do {
                    try await SupabaseOAuthManager.shared.isNeedOnboarding()
                } catch {
                    self.showLoginView()
                }
            } else {
                await MainActor.run {
                    self.showLoginView()
                }
            }
        }
    }

    // 나중에 지울 코드
    //----------------------------------
    func showOnboardingView() {
        let nav = UINavigationController(rootViewController: DIContainer.shared.makeOnboardingViewController())
        nav.setNavigationBarHidden(true, animated: true)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }

    func showLoginView() {
        let vm = LoginViewModel()
        self.window?.rootViewController = LoginViewController(viewModel: vm)
        self.window?.makeKeyAndVisible()
    }

    func showMainView() {
        let vc = TabBarViewController(viewControllers: [
            UINavigationController(rootViewController: HomeViewController()),
            UINavigationController(rootViewController: CameraViewController()),
            UINavigationController(rootViewController: DIContainer.shared.makeMyPageViewController())
        ])
        window?.rootViewController = vc // DummyViewController(viewModel: vm)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .gray0
    }
}

final class AVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        setNavigationBar(alignment: .left, title: "메인")
    }
}
//----------------------------------
