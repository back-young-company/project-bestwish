//
//  SceneDelegate.swift
//  BestWish
//
//  Created by 이수현 on 6/3/25.
//

import BestWishPresentation
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        
        if url.scheme == "bestwish" {
            // URL 파싱 및 라우팅
            NSLog("📦 딥링크 URL 수신: \(url.absoluteString)")
        }
    }

    func scene(
            _ scene: UIScene,
            willConnectTo session: UISceneSession,
            options connectionOptions: UIScene.ConnectionOptions
        ) {
            guard let windowScene = (scene as? UIWindowScene) else { return }
            /// 서비스 이용순서
            /// 1. 소셜 로그인 성공 유무 판단 -> checkLoginState (기기 내의 supabase의 연결할 토큰확인 (키체인으로 저장)
            ///     a. 로그인 성공시 -> checkSignInState (supabase public.UserInfo 테이블에서 role 값 확인하기 ( GUEST = 회원가입 실패 / USER = 회원가입 성공)
            ///         i. 회원가입 성공유무 판단
            ///     b. 로그인 실패시
            ///         i. 로그인 재시도
            ///
            /// a. 로그인 성공시
            ///     i. 회원가입 성공시
            ///         1. 홈화면 실행
            ///     ii.회원가입 실패시
            ///         1. 회원가입부터 실행
            ///
            /// Task 구현이 안전하지 않을시 다른 방법 고려 가능


            let window = UIWindow(windowScene: windowScene)
            self.window = window

            // placeholder 루트 설정
            window.rootViewController = UIViewController()
            window.makeKeyAndVisible()

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

    // 나중에 지울 코드
    //----------------------------------
    func showSignInView() {
        let nav = UINavigationController(rootViewController: DIContainer.shared.makeSignInViewController())
        nav.setNavigationBarHidden(true, animated: true)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }

    func showLoginView() {
        self.window?.rootViewController = DIContainer.shared.makeLoginViewController()
        self.window?.makeKeyAndVisible()
    }

    func showMainView() {
        let vc = TabBarViewController(viewControllers: [
            UINavigationController(rootViewController: DIContainer.shared.makeHomeViewController()),
            UINavigationController(rootViewController: DIContainer.shared.makeCameraViewController()),
            UINavigationController(rootViewController: DIContainer.shared.makeMyPageViewController())
        ])
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        window?.backgroundColor = .gray0
    }
}
//----------------------------------
