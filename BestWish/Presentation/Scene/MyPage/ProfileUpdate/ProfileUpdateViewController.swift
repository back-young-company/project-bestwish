//
//  ProfileUpdateViewController.swift
//  BestWish
//
//  Created by 이수현 on 6/10/25.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileUpdateViewController: UIViewController {
    private let profileUpdateView = ProfileUpdateView()
    private let viewModel: ProfileUpdateViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: ProfileUpdateViewModel = ProfileUpdateViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = profileUpdateView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        profileUpdateView.configure(user: AccountDisplay(
            profileImageName: "person.crop.circle",
            nickname: "User",
            email: "user@gmail.com"
        ))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        profileUpdateView.addUnderLine()
    }

    private func bindViewModel() {

    }
}

