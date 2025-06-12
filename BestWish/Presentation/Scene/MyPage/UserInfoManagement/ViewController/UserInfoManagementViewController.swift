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
    private let disposeBag = DisposeBag()

    init() {
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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        managementView.addUnderLine()
    }

    private func bindView() {
        managementView.withdrawStackView.arrowButton.rx.tap
            .bind(with: self) { owner, _ in
                AlertBuilder(baseViewController: self, type: .withdraw) {
                    print("회원 탈퇴")
                }.show()
            }.disposed(by: disposeBag)
    }

    private func bindViewModel() {
        managementView.configure(loginInfo: "애플")
    }
}

