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
    }
}
