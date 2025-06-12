//
//  DatePickerBottomSheetViewController.swift
//  BestWish
//
//  Created by yimkeul on 6/11/25.
//

import UIKit

final class DatePickerBottomSheetViewController: UIViewController {
    // 외부에서 선택된 날짜 넘겨받을 클로저
    var onDateSelected: ((Date) -> Void)?
    var onCancel: (()->Void)?

    // 분리된 뷰
    private let datePickerBottomSheetView = DatePickerBottomSheetView()

    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func loadView() {
        view = datePickerBottomSheetView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        datePickerBottomSheetView.completeButton.addTarget(self, action: #selector(didTapConfirm), for: .touchUpInside)
        datePickerBottomSheetView.cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)

        presentDatePickerSheet()
    }

    // MARK: - Actions
    @objc private func didTapConfirm() {
        let selected = datePickerBottomSheetView.datePicker.date
        onDateSelected?(selected)
    }

    @objc private func didTapCancel() {
        onCancel?()
    }

    // MARK: - Sheet Configuration
    func presentDatePickerSheet() {
        modalPresentationStyle = .pageSheet
        if let sheet = sheetPresentationController {
            sheet.detents = [.custom(resolver: { _ in CGFloat(287).fitHeight })]
            sheet.preferredCornerRadius = 12
            sheet.prefersGrabberVisible = false
        }
    }
}

