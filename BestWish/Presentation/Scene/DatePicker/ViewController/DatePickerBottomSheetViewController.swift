//
//  DatePickerBottomSheetViewController.swift
//  BestWish
//
//  Created by yimkeul on 6/11/25.
//

import UIKit

import RxSwift
import RxCocoa

final class DatePickerBottomSheetViewController: UIViewController {

    // 외부에서 선택된 날짜 넘겨받을 클로저
    var onDateSelected: ((Date) -> Void)?
    var onCancel: (() -> Void)?

    // 분리된 뷰
    private let datePickerBottomSheetView = DatePickerBottomSheetView()
    private let disposeBag = DisposeBag()

    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = datePickerBottomSheetView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
        presentDatePickerSheet()
    }

    private func bindUI() {
        datePickerBottomSheetView.completeButton.rx.tap
            .withLatestFrom(datePickerBottomSheetView.datePicker.rx.date)
            .subscribe(with: self) { owner, date in
                owner.onDateSelected?(date)
            }
            .disposed(by: disposeBag)

        datePickerBottomSheetView.cancelButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.onCancel?()
            }
            .disposed(by: disposeBag)
    }

    func presentDatePickerSheet() {
        modalPresentationStyle = .pageSheet
        if let sheet = sheetPresentationController {
            sheet.detents = [.custom(resolver: { _ in CGFloat(287).fitHeight })]
            sheet.preferredCornerRadius = 12
            sheet.prefersGrabberVisible = false
        }
    }
}

