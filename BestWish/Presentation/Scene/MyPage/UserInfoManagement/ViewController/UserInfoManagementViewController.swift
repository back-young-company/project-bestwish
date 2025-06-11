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
        bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        managementView.addUnderLine()
    }

    private func bindViewModel() {

    }
}

