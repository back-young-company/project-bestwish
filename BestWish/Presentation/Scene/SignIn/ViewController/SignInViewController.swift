//
//  SignInViewController.swift
//  BestWish
//
//  Created by yimkeul on 6/9/25.
//


import UIKit

import IQKeyboardReturnManager
import RxSwift

/// 회원가입 View Controller
final class SignInViewController: UIViewController {

    private let viewModel: SignInViewModel
    private let policyViewModel: PolicyViewModel
    private let firstView = SignInFirstView()
    private let secondView = SignInSecondView()
    private let disposeBag = DisposeBag()
    private let signInViews: [UIView]
    private let returnManager: IQKeyboardReturnManager = .init()

    init(viewModel: SignInViewModel, policyViewModel: PolicyViewModel) {
        self.viewModel = viewModel
        self.policyViewModel = policyViewModel
        self.signInViews = [firstView, secondView]
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
        /// 회원가입 순서 바인딩
        viewModel.state.currentPage
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, page in
                owner.view = owner.signInViews[page]
            }
            .disposed(by: disposeBag)

        /// 회원가입 1 바인딩
        /// - firstView.configure(생일 선택, 버튼 활성화)
        /// 회원가입 2 바인딩
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

        /// 회원가입 결과에 따른 화면 이동
        viewModel.state.readyToUseService
            .observe(on: MainScheduler.instance)
            .bind { _ in
                DummyCoordinator.shared.showMainView()
            }
            .disposed(by: disposeBag)

        /// 회원가입 에러시 alert
        viewModel.state.error
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, error in
                owner.showBasicAlert(title: "네트워크 에러", message: error.localizedDescription)
                NSLog("signInViewController Error: \(error.debugDescription)")
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - private 메서드
private extension SignInViewController {
    /// 이용약관 바텀 시트 바인딩
    func bindPolicySheet() {
        viewModel.state.showPolicySheet
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, _ in
                let policyVC = PolicyViewController(viewModel: owner.policyViewModel)
                owner.present(policyVC, animated: true)
            }
            .disposed(by: disposeBag)
    }

    /// signInFirstView 바인딩
    func bindFirstView() {
        // 성별 바인딩
        firstView.genderSelection.maleButton.rx.tap
            .asDriver()
            .map { .selectedGender(.male) }
            .drive(viewModel.action)
            .disposed(by: disposeBag)

        firstView.genderSelection.femaleButton.rx.tap
            .asDriver()
            .map { .selectedGender(.female) }
            .drive(viewModel.action)
            .disposed(by: disposeBag)

        firstView.genderSelection.nothingButton.rx.tap
            .asDriver()
            .map { .selectedGender(.nothing) }
            .drive(viewModel.action)
            .disposed(by: disposeBag)

        // 생년월일 바인딩
        firstView.birthSelection.dateButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.firstView.configure(isFoucsed: true)
                let sheetVC = DatePickerBottomSheetViewController()
                sheetVC.presentationController?.delegate = owner

                // 선택된 날짜 콜백
                sheetVC.onDateSelected = { date in
                    owner.dismiss(animated: true) {
                        owner.firstView.configure(isFoucsed: false)
                    }
                    owner.viewModel.action.onNext(.selectedBirth(date))
                }

                sheetVC.onCancel = {
                    owner.dismiss(animated: false) {
                        owner.firstView.configure(isFoucsed: false)
                    }
                }
                sheetVC.presentDatePickerSheet()
                owner.present(sheetVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
    /// signInSecondView 바인딩
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
                profileSheetVC.onComplete = { selectedIndex in
                    owner.viewModel.action.onNext(.selectedProfileIndex(selectedIndex))
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

        secondView.nicknameVStackView.textField.rx.controlEvent(.editingDidBegin)
            .subscribe(with: self) { owner, _ in
                owner.secondView.nicknameVStackView.textField.layer.borderColor = UIColor.primary300?.cgColor
            }
            .disposed(by: disposeBag)

    }

    /// Oneboarding 내 화면 이동 버튼 바인딩
    func bindPageButton() {
        firstView.nextPageButton.rx.tap
            .asDriver()
            .map { .didTapNextPage }
            .drive(viewModel.action)
            .disposed(by: disposeBag)

        secondView.prevButton.rx.tap
            .asDriver()
            .map { .didTapPrevPage }
            .drive(viewModel.action)
            .disposed(by: disposeBag)

        secondView.completeButton.rx.tap
            .withLatestFrom(viewModel.state.userInfo)
            .subscribe(with: self) { owner, userInfoModel in
                guard let userInfoModel else { return }
                owner.viewModel.action.onNext(.uploadUserInfo(userInfoModel))
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - 화면 포커싱 추적
extension SignInViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        // 모달이 내려간 시점에 원래 색으로 복구
        firstView.birthSelection.dateButton.layer.borderColor = UIColor.gray200?.cgColor
    }
}
