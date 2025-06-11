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
    private let onboardingView = OnboardingFirstView()
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
        view = onboardingView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }

    // MARK: - BindViewModel
    private func bindViewModel() {
        onboardingView.genderSelection.selectedGender
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

        onboardingView.birthSelection.dateButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.onboardingView.birthSelection.dateButton.layer.borderColor = UIColor.primary300?.cgColor
                let sheetVC = DatePickerBottomSheetViewController()
                sheetVC.presentationController?.delegate = self
                // 선택된 날짜 콜백
                sheetVC.onDateSelected = { date in
                    let formatter = DateFormatter()
                    formatter.locale = Locale(identifier: "ko_KR")
                    formatter.dateFormat = "yyyy.MM.dd"
                    let title = formatter.string(from: date)
                    self.onboardingView.birthSelection.dateButton.setTitle(title, for: .normal)

                    self.dismiss(animated: false) {
                        self.onboardingView.birthSelection.dateButton.layer.borderColor = UIColor.gray200?.cgColor
                    }
                }

                sheetVC.onCancel = {
                    self.dismiss(animated: false) {
                        self.onboardingView.birthSelection.dateButton.layer.borderColor = UIColor.gray200?.cgColor
                    }
                }

                sheetVC.presentDatePickerSheet()
                self.present(sheetVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
extension OnboardingViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        // 모달이 내려간 시점에 원래 색으로 복구
        onboardingView.birthSelection.dateButton.layer.borderColor = UIColor.gray200?.cgColor
    }
}
