//
//  UserInfoManagementViewController.swift
//  BestWish
//
//  Created by 이수현 on 6/11/25.
//

import UIKit
import RxSwift
import RxCocoa

final class UserInfoManagementViewController: UIViewController {
    private let managementView = UserInfoManagementView()
    private let viewModel: UserInfoManagementViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: UserInfoManagementViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = managementView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar(alignment: .center, title: "회원 정보 관리")
        bindView()
        bindViewModel()
        viewModel.action.onNext(.getAuthProvider)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        managementView.addUnderLine()
    }

    private func bindView() {
        managementView.userInfoHorizontalStackView.arrowButton.rx.tap
            .bind(with: self) { owner, _ in
                let nextVC = DIContainer.shared.makeUserInfoUpdateViewController()
                owner.navigationController?.pushViewController(nextVC, animated: true)
            }.disposed(by: disposeBag)

        managementView.withdrawStackView.arrowButton.rx.tap
            .bind(with: self) { owner, _ in
                AlertBuilder(baseViewController: self, type: .withdraw) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        owner.viewModel.action.onNext(.withdraw)
                    }
                }.show()
            }.disposed(by: disposeBag)
    }

    private func bindViewModel() {
        viewModel.state.authProvider
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, authProvider in
                owner.managementView.configure(authProvider: authProvider)
            }.disposed(by: disposeBag)
    }
}
