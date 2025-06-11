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
        setNavigationBar(alignment: .center, title: "프로필 수정")
        bindView()
        bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        profileUpdateView.addUnderLine()
    }

    private func bindView() {
        let tapGesture = UITapGestureRecognizer()
        profileUpdateView.profileImageView.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .withLatestFrom(viewModel.state.userAccount)
            .bind(with: self) { owner, userAccount in
                let profileSheetVC = ProfileSheetViewController(selectedIndex: userAccount.profileImageIndex)
                profileSheetVC.presentProfileSheet()
                profileSheetVC.onComplete = { [weak self] selectedIndex in
                    self?.viewModel.action.onNext(.selectedProfileIndex(selectedIndex))
                }
                owner.present(profileSheetVC, animated: true)
            }.disposed(by: disposeBag)
    }

    private func bindViewModel() {
        viewModel.state.userAccount
            .bind(with: self) { owner, userAccount in
                owner.profileUpdateView.configure(user: userAccount)
            }.disposed(by: disposeBag)
    }
}
