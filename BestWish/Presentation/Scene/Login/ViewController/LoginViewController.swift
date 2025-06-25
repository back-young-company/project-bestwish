//
//  LoginViewController.swift
//  BestWish
//
//  Created by yimkeul on 6/7/25.
//

import UIKit

import RxCocoa
import RxSwift

/// 로그인 View Controller
final class LoginViewController: UIViewController {

    private let loginView = LoginView()
    private let viewModel: LoginViewModel
    private let disposeBag = DisposeBag()
    private let dummyCoordinator = DummyCoordinator.shared

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }

    private func bindViewModel() {
        bindKakaoButton()
        bindAppleButton()

        /// oauth & 온보딩 결과에 따른 화면 이동
        viewModel.state.readyToUseService
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, state in
                if state {
                    owner.dummyCoordinator.showMainView()
                } else {
                    owner.dummyCoordinator.showOnboardingView()
                }
            }.disposed(by: disposeBag)

        /// oauth & 온보딩 에러시 alert
        viewModel.state.error
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, error in
                owner.showBasicAlert(title: "인증 에러", message: error.localizedDescription)
                NSLog("LoginViewController Error: \(error.debugDescription)")
            }
            .disposed(by: disposeBag)
    }
    
    private func bindKakaoButton() {
        loginView.kakaoLoginButton.rx.tap
            .asDriver()
            .map { .signInKakao }
            .drive(viewModel.action)
            .disposed(by: disposeBag)
    }

    private func bindAppleButton() {
        loginView.appleLoginButton.rx.tap
            .asDriver()
            .map { .signInApple }
            .drive(viewModel.action)
            .disposed(by: disposeBag)
    }
}
