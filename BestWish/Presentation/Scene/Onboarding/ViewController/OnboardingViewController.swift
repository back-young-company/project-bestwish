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
    // MARK: - Properties
    private let firstView = OnboardingFirstView()
    private let secondView = OnboardingSecondView()
    private let viewModel: OnboardingViewModel
    private let disposeBag = DisposeBag()

    // MARK: - Initializer, Deinit, requiered
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle
    override func loadView() {
        view = secondView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        bindViewModel()
    }

    // MARK: - BindView
    private func bindView() {
        firstView.genderSelection.selectedGender
            .subscribe(onNext: { gender in
            switch gender {
            case .male:
                print("남 선택됨")
            case .female:
                print("여 선택됨")
            case .nothing:
                print("선택 안 함")
            default:
                break
            }
        })
            .disposed(by: disposeBag)

        firstView.birthSelection.dateButton.rx.tap
            .subscribe(onNext: { [weak self] in
            guard let self else { return }
            self.firstView.birthSelection.dateButton.layer.borderColor = UIColor.primary300?.cgColor
            let sheetVC = DatePickerBottomSheetViewController()
            sheetVC.presentationController?.delegate = self
            // 선택된 날짜 콜백
            sheetVC.onDateSelected = { date in
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "ko_KR")
                formatter.dateFormat = "yyyy.MM.dd"
                let title = formatter.string(from: date)
                self.firstView.birthSelection.dateButton.setTitle(title, for: .normal)

                self.dismiss(animated: false) {
                    self.firstView.birthSelection.dateButton.layer.borderColor = UIColor.gray200?.cgColor
                }
            }

            sheetVC.onCancel = {
                self.dismiss(animated: false) {
                    self.firstView.birthSelection.dateButton.layer.borderColor = UIColor.gray200?.cgColor
                }
            }

            sheetVC.presentDatePickerSheet()
            self.present(sheetVC, animated: true)
        })
            .disposed(by: disposeBag)

        let tapGesture = UITapGestureRecognizer()
        secondView.profileImageView.addGestureRecognizer(tapGesture)

        tapGesture.rx.event
            .withLatestFrom(viewModel.state.userInput)
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
        viewModel.state.userInput
            .bind(with: self) { owner, userInput in
                owner.secondView.configure(input: userInput)
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
