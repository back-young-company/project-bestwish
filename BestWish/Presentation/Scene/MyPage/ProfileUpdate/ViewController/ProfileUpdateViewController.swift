//
//  ProfileUpdateViewController.swift
//  BestWish
//
//  Created by 이수현 on 6/10/25.
//

import UIKit

import RxCocoa
import RxSwift

/// 프로필 업데이트 View Controller
final class ProfileUpdateViewController: UIViewController {
    private let viewModel: ProfileUpdateViewModel
    private let profileUpdateView = ProfileUpdateView()
    private let disposeBag = DisposeBag()

    init(viewModel: ProfileUpdateViewModel) {
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
        viewModel.action.onNext(.getUserInfo)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        profileUpdateView.addUnderLine()
    }

    private func bindView() {
        // 이미지뷰 제스처 추가
        let tapGesture = UITapGestureRecognizer()
        profileUpdateView.profileImageView.addGestureRecognizer(tapGesture)

        // 프로필 이미지 뷰 선택 로직
        tapGesture.rx.event
            .withLatestFrom(viewModel.state.userInfo)
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, userInfo in
                guard let userInfo else { return }
                let profileSheetVC = ProfileSheetViewController(selectedIndex: userInfo.profileImageCode)
                profileSheetVC.presentProfileSheet()
                profileSheetVC.onComplete = { selectedIndex in
                    owner.viewModel.action.onNext(.updateProfileImageCode(selectedIndex))
                }
                owner.present(profileSheetVC, animated: true)
            }.disposed(by: disposeBag)

        // 프로필 닉네임 변경 로직
        profileUpdateView.nicknameTextField.rx.text
            .orEmpty
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, nickname in
                owner.viewModel.action.onNext(.updateNickname(nickname))
            }.disposed(by: disposeBag)

        // 저장 버튼 탭 로직
        profileUpdateView.confirmButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.action.onNext(.saveUserInfo)
            }.disposed(by: disposeBag)
    }

    private func bindViewModel() {
        viewModel.state.userInfo
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, userInfo in
                guard let userInfo else { return }
                owner.profileUpdateView.configure(user: userInfo)
            }.disposed(by: disposeBag)

        viewModel.state.isValidNickname
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, isValid in
                owner.profileUpdateView.configure(isValidNickname: isValid)
            }
            .disposed(by: disposeBag)

        viewModel.state.completedSave
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)

        viewModel.state.error
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, error in
                owner.showBasicAlert(
                    title: error.alertTitle,
                    message: error.localizedDescription
                )
            }.disposed(by: disposeBag)
    }
}
