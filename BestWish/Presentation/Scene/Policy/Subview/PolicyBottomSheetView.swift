//
//  PolicyBottomSheetView.swift
//  BestWish
//
//  Created by yimkeul on 6/16/25.
//

import UIKit
import SnapKit
import Then

final class PolicyBottomSheetView: UIView {
    private let infoStackView: InfoStackView
    private let separator = UIView()
    /// 모두 동의합니다
    private let selectAllHStack = HorizontalStackView(spacing: 8)
    let selectAllCheckButton = UIButton()
    private let selectAllLabel = UILabel()

    /// 개인정보
    private let privacyHStack = HorizontalStackView(spacing: 8)
    let privacyCheckButton = UIButton()
    private let privacyLabel = UILabel()
    let privacyViewButton = UIButton()

    /// 이용약관
    private let serviceHStack = HorizontalStackView(spacing: 8)
    let serviceCheckButton = UIButton()
    private let serviceLabel = UILabel()
    let serviceViewButton = UIButton()

    let completeButton = AppButton(type: .complete)

    // MARK: - Init
    init(title: String, desc: String) {
        self.infoStackView = InfoStackView(title: title, desc: desc)
        super.init(frame: .zero)
        setView()
    }


    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }


    func configure(_ isValid: Bool) {
//        completeButton.
//        updateStyle(isValid ? .next : .nextUnable)
        completeButton.isEnabled = true
    }
}

private extension PolicyBottomSheetView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        self.backgroundColor = .gray0

        separator.do {
            $0.backgroundColor = .gray200
        }

        selectAllHStack.do {
            $0.alignment = .center
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(
                top: 12,
                left: 20,
                bottom: 12,
                right: 20
            )
        }

        selectAllCheckButton.do {
            let off = UIImage(systemName: "square")
            let on = UIImage(systemName: "checkmark.square.fill")
            $0.setImage(off, for: .normal)
            $0.setImage(on, for: .selected)
            $0.tintColor = .primary300
        }

        selectAllLabel.do {
            $0.text = PolicyText.allAgree.value
            $0.font = .font(.pretendardMedium, ofSize: 14)
            $0.textColor = .gray900
        }

        privacyHStack.do {
            $0.alignment = .center
            $0.distribution = .fill
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(
                top: 0,
                left: 20,
                bottom: 0,
                right: 20
            )
        }

        privacyCheckButton.do {
            let off = UIImage(systemName: "square")
            let on = UIImage(systemName: "checkmark.square.fill")
            $0.setImage(off, for: .normal)
            $0.setImage(on, for: .selected)
            $0.tintColor = .primary300
        }
        privacyLabel.do {
            $0.text = PolicyText.privacy.value
            $0.font = .font(.pretendardMedium, ofSize: 14)
            $0.textColor = .gray900
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }

        privacyViewButton.do {
            $0.setTitle(PolicyText.showPDF.value, for: .normal)
            $0.titleLabel?.font = .font(.pretendardMedium, ofSize: 14)
            $0.setTitleColor(.primary300, for: .normal)
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }

        serviceHStack.do {
            $0.alignment = .center
            $0.distribution = .fill
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(
                top: 0,
                left: 20,
                bottom: 0,
                right: 20
            )
        }

        serviceCheckButton.do {
            let off = UIImage(systemName: "square")
            let on = UIImage(systemName: "checkmark.square.fill")
            $0.setImage(off, for: .normal)
            $0.setImage(on, for: .selected)
            $0.tintColor = .primary300
        }
        serviceLabel.do {
            $0.text = PolicyText.service.value
            $0.font = .font(.pretendardMedium, ofSize: 14)
            $0.textColor = .gray900
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }

        serviceViewButton.do {
            $0.setTitle(PolicyText.showPDF.value, for: .normal)
            $0.titleLabel?.font = .font(.pretendardMedium, ofSize: 14)
            $0.setTitleColor(.primary300, for: .normal)
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }

        completeButton.do {
            $0.isEnabled = false
        }
    }

    func setHierarchy() {

        self.addSubviews(
            infoStackView,
            selectAllHStack,
            separator,
            privacyHStack,
            serviceHStack,
            completeButton
        )

        selectAllHStack.addArrangedSubviews(selectAllCheckButton, selectAllLabel)
        privacyHStack.addArrangedSubviews(privacyCheckButton, privacyLabel, privacyViewButton)
        serviceHStack.addArrangedSubviews(serviceCheckButton, serviceLabel, serviceViewButton)
    }

    func setConstraints() {
        infoStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(CGFloat(38 + 16).fitHeight)
            $0.leading.trailing.equalToSuperview().inset(20)
        }


        selectAllHStack.snp.makeConstraints {
            $0.top.equalTo(infoStackView.snp.bottom).offset(CGFloat(32).fitHeight)
            $0.leading.trailing.equalToSuperview()
        }

        selectAllCheckButton.snp.makeConstraints {
            $0.size.equalTo(24)
        }
        separator.snp.makeConstraints {
            $0.top.equalTo(selectAllHStack.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }

        privacyHStack.snp.makeConstraints {
            $0.top.equalTo(separator.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
        }
        privacyCheckButton.snp.makeConstraints {
            $0.size.equalTo(24)
        }

        serviceHStack.snp.makeConstraints {
            $0.top.equalTo(privacyHStack.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        serviceCheckButton.snp.makeConstraints {
            $0.size.equalTo(24)
        }

        completeButton.snp.makeConstraints {
            $0.top.equalTo(serviceHStack.snp.bottom).offset(CGFloat(32).fitHeight)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(CGFloat(53).fitHeight)
        }
    }
}
