//
//  DatePickerBottomSheetView.swift
//  BestWish
//
//  Created by yimkeul on 6/11/25.
//

import UIKit

internal import SnapKit
internal import Then

/// DatePicker 하단 바텀 시트 내 화면
final class DatePickerBottomSheetView: UIView {

    // MARK: - Private Property
    private let _rootVStack = VerticalStackView(spacing: 12)
    private let _datePicker = UIDatePicker()
    private let _buttonHStackView = HorizontalStackView(spacing: CGFloat(12).fitWidth)
    private let _cancelButton = AppButton(type: .cancel)
    private let _completeButton = AppButton(type: .complete)

    // MARK: - Internal Property
    var datePicker: UIDatePicker { _datePicker }
    var cancelButton: AppButton { _cancelButton }
    var completeButton: AppButton { _completeButton }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    /// 기본 Date 설정
    func configure(baseDate: Date?) {
        _datePicker.date = baseDate ?? Date()
    }
}

// MARK: - private 메서드
private extension DatePickerBottomSheetView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        self.backgroundColor = .gray0

        _rootVStack.do {
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(
                top: 12,
                left: 20,
                bottom: 12,
                right: 20
            )
        }

        _datePicker.do {
            $0.datePickerMode = .date
            $0.preferredDatePickerStyle = .wheels
        }

        _buttonHStackView.do {
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(
                top: 12,
                left: 0,
                bottom: 12,
                right: 0
            )
        }
    }

    func setHierarchy() {
        self.addSubviews(_rootVStack)
        _rootVStack.addArrangedSubviews(_datePicker, _buttonHStackView)
        _buttonHStackView.addArrangedSubviews(_cancelButton, _completeButton)
    }

    func setConstraints() {
        _rootVStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        _cancelButton.snp.makeConstraints {
            $0.width.equalTo(CGFloat(80).fitWidth)
            $0.height.equalTo(CGFloat(53).fitHeight)
        }

        _completeButton.snp.makeConstraints {
            $0.height.equalTo(CGFloat(53).fitHeight)
        }
    }
}
