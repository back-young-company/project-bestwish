//
//  PolicyViewController.swift
//  BestWish
//
//  Created by yimkeul on 6/16/25.
//

import UIKit

internal import RxSwift

/// 이용약관 View Controller
public final class PolicyViewController: UIViewController {
    private let viewModel: PolicyViewModel
    private let policyView = PolicyBottomSheetView(
        title: PolicyText.title.value,
        desc: PolicyText.desc.value
    )
    private let disposeBag = DisposeBag()

    public init(viewModel: PolicyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        view = policyView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        bindViewModel()
    }

    private func bindView() {
        bindPDFButton()
        bindCheckboxButton()
        bindButtons()
    }

    private func bindViewModel() {
        viewModel.state.isPrivacySelected
            .bind(to: policyView.privacyPolicyCheckButton.rx.isSelected)
            .disposed(by: disposeBag)

        viewModel.state.isServiceSelected
            .bind(to: policyView.termsOfUseCheckButton.rx.isSelected)
            .disposed(by: disposeBag)

        viewModel.state.isAllSelected
            .distinctUntilChanged()
            .bind(with: self) { owner, all in
            owner.policyView.selectAllCheckButton.isSelected = all
            owner.policyView.configure(all)
        }
            .disposed(by: disposeBag)
    }

    /// pdf 열기 버튼 바인딩
    private func bindPDFButton() {
        policyView.privacyPolicyViewButton.rx.tap
            .subscribe(with: self) { owner, _ in
            let pdfVC = PDFViewController(type: .privacyPolicy)
            if let sheet = pdfVC.sheetPresentationController {
                sheet.detents = [.large()]
                sheet.prefersGrabberVisible = false
            }
            owner.present(pdfVC, animated: true)
        }
            .disposed(by: disposeBag)

        policyView.termsOfUseViewButton.rx.tap
            .subscribe(with: self) { owner, _ in
            let pdfVC = PDFViewController(type: .termsOfUse)
            if let sheet = pdfVC.sheetPresentationController {
                sheet.detents = [.large()]
                sheet.prefersGrabberVisible = false
            }
            owner.present(pdfVC, animated: true)
        }
            .disposed(by: disposeBag)
    }
    /// 다음 버튼 바인딩
    private func bindButtons() {
        policyView.completeButton.rx.tap
            .withLatestFrom(viewModel.state.isAllSelected)
            .filter { $0 }
            .bind(with: self) { owner, _ in
            owner.dismiss(animated: true)
        }
            .disposed(by: disposeBag)
    }

    /// checkbox 버튼 바인딩
    private func bindCheckboxButton() {
        policyView.privacyPolicyCheckButton.rx.tap
            .asDriver()
            .map { .privacyCheckboxTapped }
            .drive(viewModel.action)
            .disposed(by: disposeBag)

        policyView.termsOfUseCheckButton.rx.tap
            .asDriver()
            .map { .serviceCheckboxTapped }
            .drive(viewModel.action)
            .disposed(by: disposeBag)


        policyView.selectAllCheckButton.rx.tap
            .asDriver()
            .map { .selectAllCheckboxTapped }
            .drive(viewModel.action)
            .disposed(by: disposeBag)


    }
}
