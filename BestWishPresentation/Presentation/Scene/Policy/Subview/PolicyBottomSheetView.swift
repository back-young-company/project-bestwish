//
//  PolicyBottomSheetView.swift
//  BestWish
//
//  Created by yimkeul on 6/16/25.
//

import UIKit

internal import SnapKit
internal import Then

/// 정책 확인 바텀 시트 화면
final class PolicyBottomSheetView: UIView {

    // MARK: - Private Property
    private let _infoStackView: IntroTextStackView
    private let _separator = UIView()
    private let _selectAllHStack = HorizontalStackView(spacing: 8)
    private let _selectAllCheckButton = UIButton()
    private let _selectAllLabel = UILabel()
    private let _privacyPolicyHStack = HorizontalStackView(spacing: 8)
    private let _privacyPolicyCheckButton = UIButton()
    private let _privacyPolicyLabel = UILabel()
    private let _privacyPolicyViewButton = UIButton()
    private let _termsOfUseHStack = HorizontalStackView(spacing: 8)
    private let _termsOfUseCheckButton = UIButton()
    private let _termsOfUseLabel = UILabel()
    private let _termsOfUseViewButton = UIButton()
    private let _completeButton = AppButton(type: .complete)

    // MARK: - Internal Property
    var selectAllCheckButton: UIButton { _selectAllCheckButton }
    var privacyPolicyCheckButton: UIButton { _privacyPolicyCheckButton }
    var privacyPolicyViewButton: UIButton { _privacyPolicyViewButton }
    var termsOfUseCheckButton: UIButton { _termsOfUseCheckButton }
    var termsOfUseViewButton: UIButton { _termsOfUseViewButton }
    var completeButton: AppButton { _completeButton }

    init(title: String, desc: String) {
        self._infoStackView = IntroTextStackView(title: title, desc: desc)
        super.init(frame: .zero)
        setView()
    }

    required init?(coder: NSCoder) { fatalError() }

    /// 이용약관 동의  완료 후 활성화 설정
    func configure(_ isValid: Bool) {
        _completeButton.isEnabled = isValid
    }
}

// MARK: - private 메서드
private extension PolicyBottomSheetView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        self.backgroundColor = .gray0

        _separator.do {
            $0.backgroundColor = .gray200
        }

        _selectAllHStack.do {
            $0.alignment = .center
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(
                top: 12,
                left: 20,
                bottom: 12,
                right: 20
            )
        }

        _selectAllCheckButton.do {
            let off = UIImage(systemName: "square")
            let on = UIImage(systemName: "checkmark.square.fill")
            $0.setImage(off, for: .normal)
            $0.setImage(on, for: .selected)
            $0.tintColor = .primary300
            var config = UIButton.Configuration.plain()
            config.imagePadding = 0
            config.contentInsets = .init(top: 12, leading: .zero, bottom: 12, trailing: .zero)
            config.background.backgroundColor = .clear
            $0.configuration = config
        }

        _selectAllLabel.do {
            $0.text = PolicyText.allAgree.value
            $0.font = .font(.pretendardMedium, ofSize: 14)
            $0.textColor = .gray900
        }

        _privacyPolicyHStack.do {
            $0.alignment = .center
            $0.distribution = .fill
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(
                top: 0,
                left: 20,
                bottom: 12,
                right: 20
            )
        }

        _privacyPolicyCheckButton.do {
            let off = UIImage(systemName: "square")
            let on = UIImage(systemName: "checkmark.square.fill")
            $0.setImage(off, for: .normal)
            $0.setImage(on, for: .selected)
            $0.tintColor = .primary300

            var config = UIButton.Configuration.plain()
            config.imagePadding = 0
            config.contentInsets = .init(top: 12, leading: .zero, bottom: 12, trailing: .zero)
            config.background.backgroundColor = .clear
            $0.configuration = config
        }
        _privacyPolicyLabel.do {
            $0.text = PolicyText.privacy.value
            $0.font = .font(.pretendardMedium, ofSize: 14)
            $0.textColor = .gray900
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }

        _privacyPolicyViewButton.do {
            $0.setTitle(PolicyText.showPDF.value, for: .normal)
            $0.titleLabel?.font = .font(.pretendardMedium, ofSize: 14)
            $0.setTitleColor(.primary300, for: .normal)
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }

        _termsOfUseHStack.do {
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

        _termsOfUseCheckButton.do {
            let off = UIImage(systemName: "square")
            let on = UIImage(systemName: "checkmark.square.fill")
            $0.setImage(off, for: .normal)
            $0.setImage(on, for: .selected)
            $0.tintColor = .primary300
            var config = UIButton.Configuration.plain()
            config.imagePadding = 0
            config.contentInsets = .init(top: 12, leading: .zero, bottom: 12, trailing: .zero)
            config.background.backgroundColor = .clear
            $0.configuration = config
        }
        _termsOfUseLabel.do {
            $0.text = PolicyText.service.value
            $0.font = .font(.pretendardMedium, ofSize: 14)
            $0.textColor = .gray900
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }

        _termsOfUseViewButton.do {
            $0.setTitle(PolicyText.showPDF.value, for: .normal)
            $0.titleLabel?.font = .font(.pretendardMedium, ofSize: 14)
            $0.setTitleColor(.primary300, for: .normal)
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }

        _completeButton.do {
            $0.isEnabled = false
        }
    }

    func setHierarchy() {

        self.addSubviews(
            _infoStackView,
            _selectAllHStack,
            _separator,
            _privacyPolicyHStack,
            _termsOfUseHStack,
            _completeButton
        )

        _selectAllHStack.addArrangedSubviews(_selectAllCheckButton, _selectAllLabel)
        _privacyPolicyHStack.addArrangedSubviews(_privacyPolicyCheckButton, _privacyPolicyLabel, _privacyPolicyViewButton)
        _termsOfUseHStack.addArrangedSubviews(_termsOfUseCheckButton, _termsOfUseLabel, _termsOfUseViewButton)
    }

    func setConstraints() {
        _infoStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(CGFloat(54).fitHeight)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        _selectAllHStack.snp.makeConstraints {
            $0.top.equalTo(_infoStackView.snp.bottom).offset(CGFloat(32).fitHeight)
            $0.leading.trailing.equalToSuperview()
        }

        _selectAllCheckButton.snp.makeConstraints {
            $0.size.equalTo(24)
        }

        _separator.snp.makeConstraints {
            $0.top.equalTo(_selectAllHStack.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }

        _privacyPolicyHStack.snp.makeConstraints {
            $0.top.equalTo(_separator.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
        }

        _privacyPolicyCheckButton.snp.makeConstraints {
            $0.size.equalTo(24)
        }

        _termsOfUseHStack.snp.makeConstraints {
            $0.top.equalTo(_privacyPolicyHStack.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        _termsOfUseCheckButton.snp.makeConstraints {
            $0.size.equalTo(24)
        }

        _completeButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(CGFloat(53).fitHeight)
        }
    }
}
