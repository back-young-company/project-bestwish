//
//  NicknameInputView.swift
//  BestWish
//
//  Created by yimkeul on 6/12/25.
//

import UIKit

import SnapKit
import Then

/// 닉네임 입력 화면
final class NicknameInputView: UIView {

    // MARK: - Private Property
    private let _rootVStackView = VerticalStackView(spacing: 12)
    private let _nicknameLabel = GroupTitleLabel(title: "닉네임")
    private let _textField = UITextField()
    private let _cautionLabel = UILabel()

    // MARK: - Internal Property
    var textField: UITextField { _textField }
    var cautionLabel: UILabel { _cautionLabel }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - private 메서드
private extension NicknameInputView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        _textField.do {
            $0.font = .font(.pretendardMedium, ofSize: 16)
            $0.backgroundColor = .gray0
            $0.layer.borderWidth = 1.5
            $0.layer.borderColor = UIColor.gray200?.cgColor
            $0.layer.cornerRadius = 8
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
            $0.leftViewMode = .always
        }

        _cautionLabel.do {
            $0.text = OnboardingText.secondCaution.value
            $0.font = .font(.pretendardMedium, ofSize: 12)
            $0.textColor = .gray200
        }
    }

    func setHierarchy() {
        self.addSubview(_rootVStackView)
        _rootVStackView.addArrangedSubviews(_nicknameLabel, _textField, _cautionLabel)
    }

    func setConstraints() {
        _rootVStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        _nicknameLabel.snp.makeConstraints {
            $0.height.equalTo(CGFloat(17).fitHeight)
        }

        _cautionLabel.snp.makeConstraints {
            $0.height.equalTo(CGFloat(14).fitHeight)
        }

        _textField.snp.makeConstraints {
            $0.height.equalTo(CGFloat(48).fitHeight)
        }
    }
}

