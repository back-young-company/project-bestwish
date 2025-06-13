//
//  OnboardingViewController.swift
//  BestWish
//
//  Created by yimkeul on 6/9/25.
//

import Foundation
import UIKit
import RxSwift

final class OnboardingViewController: UIViewController {
    private let firstView = OnboardingFirstView()
    private let secondView = OnboardingSecondView()
    private let viewModel: OnboardingViewModel
    private let disposeBag = DisposeBag()
    private let onboardingViews: [UIView]

    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        self.onboardingViews = [firstView, secondView]
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = firstView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        bindViewModel()
    }


    private func bindView() {
        bindFirstView()
        bindSecondView()
        bindPageButton()
    }

    private func bindViewModel() {
        viewModel.state.userInfo
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, userInfo in
                owner.firstView.birthSelection.configure(title: userInfo.birthString)
        }
            .disposed(by: disposeBag)

        viewModel.state.currentPage
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, page in
            self.view = owner.onboardingViews[page]
        }
            .disposed(by: disposeBag)

        viewModel.state.userInfo
            .bind(with: self) { owner, userInput in
            owner.secondView.configure(input: userInput)
        }
            .disposed(by: disposeBag)

        viewModel.state.userInfo
            .map { input in
            return input.gender != nil && input.birth != nil
        }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, isValid in
            owner.firstView.nextPageButton.isEnabled = isValid
            owner.firstView.configure(isValid)
        }
            .disposed(by: disposeBag)

        Observable
            .combineLatest(
            viewModel.state.userInfo.map { $0.nickname != nil },
            viewModel.state.isValidNickname
        ) { hasNick, isValid in
            hasNick && isValid
        }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, enabled in
            owner.secondView.completeButton.isEnabled = enabled
            owner.secondView.configure(enabled)
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

private extension OnboardingViewController {
    private func bindFirstView() {
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
            owner.firstView.birthSelection.dateButton.layer.borderColor = UIColor.primary300?.cgColor
            let sheetVC = DatePickerBottomSheetViewController()
            sheetVC.presentationController?.delegate = self
            // 선택된 날짜 콜백
            sheetVC.onDateSelected = { date in
                self.dismiss(animated: true) {
                    self.firstView.birthSelection.dateButton.layer.borderColor = UIColor.gray200?.cgColor
                }
                owner.viewModel.action.onNext(.selectedBirth(date))
            }

            sheetVC.onCancel = {
                self.dismiss(animated: false) {
                    self.firstView.birthSelection.dateButton.layer.borderColor = UIColor.gray200?.cgColor
                }
            }

            sheetVC.presentDatePickerSheet()
            self.present(sheetVC, animated: true)
        }
            .disposed(by: disposeBag)
    }

    private func bindSecondView() {
        // 프로필 사진 바인딩
        let tapGesture = UITapGestureRecognizer()
        secondView.profileImageView.addGestureRecognizer(tapGesture)

        tapGesture.rx.event
            .withLatestFrom(viewModel.state.userInfo)
            .bind(with: self) { owner, userAccount in
            let profileSheetVC = ProfileSheetViewController(selectedIndex: userAccount.profileImageIndex)
            profileSheetVC.presentProfileSheet()
            profileSheetVC.onComplete = { [weak self] selectedIndex in
                self?.viewModel.action.onNext(.selectedProfileIndex(selectedIndex))
            }
            owner.present(profileSheetVC, animated: true)
        }.disposed(by: disposeBag)

        // 닉네임 바인딩
        /// 1) 텍스트 스트림
        let textStream = secondView.nicknameStackView.textField.rx.text.orEmpty
            .skip(2)

        /// 2) 텍스트+유효성 스트림
        let validationStream: Observable<(String, Bool)> = textStream
            .map { text in
            let isValid = NSPredicate(
                format: "SELF MATCHES %@",
                "^[가-힣A-Za-z0-9]{2,10}$"
            ).evaluate(with: text)
            return (text, isValid)
        }
            .distinctUntilChanged { prev, curr in
            prev.0 == curr.0 && prev.1 == curr.1
        }

        /// 3) 구독
        validationStream
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, data in
            let (text, isValid) = data
            owner.secondView.nicknameStackView.textField.layer.borderColor =
                isValid ? UIColor.primary300?.cgColor // 허용 값
            : UIColor.red0?.cgColor // 불허 값

            owner.secondView.nicknameStackView.cautionLabel.textColor =
                isValid ? .gray200 : .red0

                // 닉네임 유효성 검사 성공시 전달
            owner.viewModel.action.onNext(.inputNicknameValid(isValid))

            if isValid {
                // 닉네임 유효성 검사 성공시 닉네임 전달
                owner.viewModel.action.onNext(.inputNickname(text))
            }
        }
            .disposed(by: disposeBag)

    }

    private func bindPageButton() {
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
            .subscribe(onNext: { display in
            print("Display:", display)
            print("성별:", display.gender ?? "없음")
            print("생일:", display.birth ?? "없음")
            print("사진:", display.profileImageIndex)
            print("닉네임:", display.nickname ?? "없음")

        })
            .disposed(by: disposeBag)
    }
}
