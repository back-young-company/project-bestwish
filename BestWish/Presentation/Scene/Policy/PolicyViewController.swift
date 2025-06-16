//
//  PolicyViewController.swift
//  BestWish
//
//  Created by yimkeul on 6/16/25.
//

import UIKit
import RxSwift

final class PolicyViewController: UIViewController {
    private let policyView = PolicyBottomSheetView(title: PolicyText.title.value, desc: PolicyText.desc.value)
    private let viewModel: PolicyViewModel
    private let disposeBag = DisposeBag()

    // MARK: - Initializer, Deinit, requiered
    init(viewModel: PolicyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle
    override func loadView() {
        view = policyView
    }

    override func viewDidLoad() {
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
            .bind(to: policyView.privacyCheckButton.rx.isSelected)
            .disposed(by: disposeBag)

        viewModel.state.isServiceSelected
            .bind(to: policyView.serviceCheckButton.rx.isSelected)
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
        policyView.privacyViewButton.rx.tap
            .subscribe(with: self) { owner, _ in
            let pdfVC = PDFViewController(type: .privacy)
            if let sheet = pdfVC.sheetPresentationController {
                sheet.detents = [.large()]
                sheet.prefersGrabberVisible = false
            }
            owner.present(pdfVC, animated: true)
        }
            .disposed(by: disposeBag)

        policyView.serviceViewButton.rx.tap
            .subscribe(with: self) { owner, _ in
            let pdfVC = PDFViewController(type: .service)
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
        policyView.privacyCheckButton.rx.tap
            .asDriver()
            .map { .privacyCheckboxTapped }
            .drive(viewModel.action)
            .disposed(by: disposeBag)

        policyView.serviceCheckButton.rx.tap
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
