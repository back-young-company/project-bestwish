//
//  LoginViewController.swift
//  BestWish
//
//  Created by yimkeul on 6/7/25.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    // MARK: - Properties
    private let loginView = LoginView()
    private let viewModel: LoginViewModel
    private let disposeBag = DisposeBag()

    // MARK: - Initializer, Deinit, requiered
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle
    override func loadView() {
        view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }

    // MARK: - BindViewModel
    private func bindViewModel() {
        bindKakaoButton()
    }

    private func bindKakaoButton() {
        loginView.kakaoLoginButton.rx.tap
                 .do(onNext: { print("Kakao 버튼 탭 감지") })
                 .map { LoginViewModel.Action.signInKakao(()) }
                 .bind(to: viewModel.action)
                 .disposed(by: disposeBag)
    }
}
