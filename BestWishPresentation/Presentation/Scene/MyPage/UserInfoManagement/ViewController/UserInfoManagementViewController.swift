//
//  UserInfoManagementViewController.swift
//  BestWish
//
//  Created by 이수현 on 6/11/25.
//

import UIKit

internal import RxCocoa
internal import RxSwift

/// 유저 정보 관리 View Controller
public final class UserInfoManagementViewController: UIViewController {

    private let viewModel: UserInfoManagementViewModel
    private let managementView = UserInfoManagementView()
    private let disposeBag = DisposeBag()
    public weak var flowDelegate: MyPageFlowDelegate? // 화면 이동 딜리게이트

    public init(viewModel: UserInfoManagementViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        view = managementView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar(alignment: .center, title: "회원 정보 관리")
        bindView()
        bindViewModel()
        viewModel.action.onNext(.getAuthProvider)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        managementView.addUnderLine()
    }

    private func bindView() {
        managementView.userInfoArrowButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.flowDelegate?.didTapUserInfoUpdateCell()
//                let nextVC = DIContainer.shared.makeUserInfoUpdateViewController()
//                owner.navigationController?.pushViewController(nextVC, animated: true)
            }.disposed(by: disposeBag)

        managementView.withdrawButton.rx.tap
            .bind(with: self) { owner, _ in
                AlertBuilder(baseViewController: owner, type: .withdraw) {
                    owner.viewModel.action.onNext(.withdraw)
                }.show()
            }.disposed(by: disposeBag)
    }

    private func bindViewModel() {
        viewModel.state.authProvider
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, authProvider in
                owner.managementView.configure(authProvider: authProvider)
            }.disposed(by: disposeBag)

        viewModel.state.isWithdraw
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.flowDelegate?.didTapWithdraw()
//                DummyCoordinator.shared.showLoginView()
            }.disposed(by: disposeBag)

        viewModel.state.isLoading
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, isLoading in
                owner.managementView.showLoading(isLoading)
            }
            .disposed(by: disposeBag)

        viewModel.state.error
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, error in
                owner.showBasicAlert(title: "네트워크 에러", message: error.localizedDescription)
                NSLog("UserInfoManagementViewController Error: \(error.debugDescription)")
            }.disposed(by: disposeBag)
    }
}
