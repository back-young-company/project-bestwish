//
//  DatePickerBottomSheetView.swift
//  BestWish
//
//  Created by yimkeul on 6/11/25.
//

import UIKit
import SnapKit
import Then

final class DatePickerBottomSheetView: UIView {

    private let stack = VerticalStackView(spacing: 12)
    let datePicker = UIDatePicker()
    private let buttonStack = HorizontalStackView(spacing: 12)
    let cancelButton = AppButton(type: .cancel)
    let completeButton = AppButton(type: .complete)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

}

private extension DatePickerBottomSheetView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        self.backgroundColor = .gray0

        stack.do {
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(
                top: 12,
                left: 20,
                bottom: 12,
                right: 20
            )
        }

        datePicker.do {
            $0.datePickerMode = .date
            $0.preferredDatePickerStyle = .wheels
        }

        buttonStack.do {
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
        self.addSubviews(stack)
        stack.addArrangedSubviews(datePicker, buttonStack)
        buttonStack.addArrangedSubviews(cancelButton, completeButton)
    }

    func setConstraints() {
        stack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        buttonStack.snp.makeConstraints {
            $0.height.equalTo(CGFloat(53+24).fitHeight)
        }

        cancelButton.snp.makeConstraints {
            $0.width.equalTo(CGFloat(80).fitWidth)
        }
/// 필요시 사용하기 (제약조건 경고가 발생됨을 확인해서 주석처리함)
//        completeButton.snp.makeConstraints {
//            $0.width.equalTo(CGFloat(243).fitWidth)
//        }
    }
}
