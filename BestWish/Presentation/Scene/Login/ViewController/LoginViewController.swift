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
