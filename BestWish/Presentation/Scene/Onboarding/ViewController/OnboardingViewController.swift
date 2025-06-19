//
//  OnboardingViewController.swift
//  BestWish
//
//  Created by yimkeul on 6/9/25.
//

import Foundation
import UIKit
import RxSwift
import IQKeyboardReturnManager

final class OnboardingViewController: UIViewController {
    private let firstView = OnboardingFirstView()
    private let secondView = OnboardingSecondView()
    private let viewModel: OnboardingViewModel
    private let policyViewModel: PolicyViewModel
    private let disposeBag = DisposeBag()
    private let onboardingViews: [UIView]
    private let returnManager: IQKeyboardReturnManager = .init()

    init(viewModel: OnboardingViewModel, policyViewModel: PolicyViewModel) {
        self.viewModel = viewModel
        self.policyViewModel = policyViewModel
        self.onboardingViews = [firstView, secondView]
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.action.onNext(.viewDidAppear)
        viewModel.action.onNext(.createUserInfo)
    }


    override func loadView() {
        view = firstView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        returnManager.lastTextInputViewReturnKeyType = .done
        bindView()
        bindViewModel()
    }

    private func bindView() {
        bindPolicySheet()
        bindFirstView()
        bindSecondView()
        bindPageButton()
    }

    private func bindViewModel() {
        /// 온보딩 순서 바인딩
        viewModel.state.currentPage
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, page in
            self.view = owner.onboardingViews[page]
        }
            .disposed(by: disposeBag)

        /// 온보딩 1 바인딩
        /// - firstView.configure(생일 선택, 버튼 활성화)
        /// 온보딩 2 바인딩
        /// - 프로필 사진 바인딩
        viewModel.state.userInfo
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, userInfo in
            owner.firstView.configure(with: userInfo)
            owner.secondView.configure(imageName: userInfo?.profileImageName)
        }
            .disposed(by: disposeBag)

        /// 닉네임 유효성 검사 바인딩
        /// secondView.configure(textField,caution 색상, 버튼 활성화)
        viewModel.state.isValidNickname
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, isValid in
            owner.secondView.configure(isValidNickname: isValid)
        }
            .disposed(by: disposeBag)
    }
}


private extension OnboardingViewController {
    func bindPolicySheet() {
        viewModel.state.showPolicySheet
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, _ in
            let policyVC = PolicyViewController(viewModel: self.policyViewModel)
            owner.present(policyVC, animated: true)
        }
            .disposed(by: disposeBag)
    }

    func bindFirstView() {
        // 성별 바인딩
        firstView.genderSelection.selectedGender
            .skip(1)
            .subscribe(with: self) { owner, gender in
            owner.viewModel.action.onNext(.selectedGender(gender ?? .nothing))
        }
            .disposed(by: disposeBag)

        // 생일 바인딩
        firstView.birthSelection.dateButton.rx.tap
            .subscribe(with: self) { owner, _ in
            let sheetVC = DatePickerBottomSheetViewController()
            sheetVC.presentationController?.delegate = self
            // 선택된 날짜 콜백
            sheetVC.onDateSelected = { date in
                owner.dismiss(animated: true) {
                    owner.firstView.configure()
                }
                owner.viewModel.action.onNext(.selectedBirth(date))
            }

            sheetVC.onCancel = {
                owner.dismiss(animated: false) {
                    owner.firstView.configure()
                }
            }
            sheetVC.presentDatePickerSheet()
            owner.present(sheetVC, animated: true)
        }
            .disposed(by: disposeBag)
    }

    func bindSecondView() {
        // 프로필 사진 바인딩
        let tapGesture = UITapGestureRecognizer()
        secondView.profileImageView.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .withLatestFrom(viewModel.state.userInfo)
            .bind(with: self) { owner, userInfo in
            guard let userInfo else { return }
            let profileSheetVC = ProfileSheetViewController(selectedIndex: userInfo.profileImageCode)
            profileSheetVC.presentProfileSheet()
            profileSheetVC.onComplete = { [weak self] selectedIndex in
                self?.viewModel.action.onNext(.selectedProfileIndex(selectedIndex))
            }
            owner.present(profileSheetVC, animated: true)
        }
            .disposed(by: disposeBag)

        // 닉네임 바인딩
        secondView.nicknameVStackView.textField.rx.text.orEmpty
            .skip(2)
            .distinctUntilChanged()
            .debounce(.microseconds(300), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, nickname in
            owner.viewModel.action.onNext(.inputNickname(nickname))
        }
            .disposed(by: disposeBag)
    }

    func bindPageButton() {
        firstView.nextPageButton.rx.tap
            .asDriver()
            .map { .nextPage }
            .drive(viewModel.action)
            .disposed(by: disposeBag)

        secondView.prevButton.rx.tap
            .asDriver()
            .map { .prevPage }
            .drive(viewModel.action)
            .disposed(by: disposeBag)

        // TODO: 메인화면으로 이동해야함.
        secondView.completeButton.rx.tap
            .withLatestFrom(viewModel.state.userInfo)
            .subscribe(with: self) { owner, userInfoDisplay in
            guard let userInfoDisplay else { return }
            owner.viewModel.action.onNext(.uploadUserInfo(userInfoDisplay))
        }
            .disposed(by: disposeBag)
    }
}


extension OnboardingViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        // 모달이 내려간 시점에 원래 색으로 복구
        firstView.birthSelection.dateButton.layer.borderColor = UIColor.gray200?.cgColor
    }
}
