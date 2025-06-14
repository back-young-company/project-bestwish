//
//  OnboardingSecondView.swift
//  BestWish
//
//  Created by yimkeul on 6/12/25.
//

import UIKit
import SnapKit
import Then

final class OnboardingSecondView: UIView {
    private let header = OnboardingHeaderView(current: 2, total: 2,
                                              title: OnboardingText.secondTitle.value,
                                              desc: OnboardingText.secondDesc.value)
    private let stackView = VerticalStackView(spacing: 40)
    private let profileContainer = UIView()
    let profileImageView = UIImageView()
    let nicknameStackView = NicknameInputView()

    private let buttonStack = HorizontalStackView(spacing: 12)
    let prevButton = AppButton(type: .before)
    let completeButton = AppButton(type: .complete)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(input: OnboardingDisplay) {
        profileImageView.image = UIImage(named: input.profileImageName)?.resize(to: CGSize(width: CGFloat(152).fitWidth, height: CGFloat(152).fitHeight))

    }

    func configure(_ isValid: Bool) {
        completeButton.updateStyle(isValid ? .complete : .incomplete)
    }

}

private extension OnboardingSecondView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setDelegate()
        setDataSource()
        setBindings()
    }

    func setAttributes() {
        self.backgroundColor = .gray0

        stackView.do {
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(
                top: 16,
                left: 20,
                bottom: 16,
                right: 20
            )
        }

        profileImageView.do {
            $0.contentMode = .scaleToFill
            $0.layer.cornerRadius = CGFloat(152).fitWidth / 2
            $0.clipsToBounds = true
            $0.isUserInteractionEnabled = true
        }

        buttonStack.do {
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(
                top: 12,
                left: 20,
                bottom: 12,
                right: 20
            )
        }

        completeButton.do {
            $0.isEnabled = false
        }
    }

    func setHierarchy() {
        self.addSubviews(header, stackView, buttonStack)
        stackView.addArrangedSubviews(profileContainer, nicknameStackView)
        profileContainer.addSubview(profileImageView)
        buttonStack.addArrangedSubviews(prevButton, completeButton)
    }

    func setConstraints() {
         header.snp.makeConstraints {
             $0.top.equalTo(safeAreaLayoutGuide).offset(38)
             $0.leading.trailing.equalToSuperview()
         }

         stackView.snp.makeConstraints {
             $0.top.equalTo(header.snp.bottom).offset(24)
             $0.leading.trailing.equalToSuperview()
         }

        profileContainer.snp.makeConstraints {
            $0.height.equalTo(CGFloat(152).fitWidth)
        }

        profileImageView.snp.makeConstraints {
            $0.height.equalTo(CGFloat(152).fitWidth)
            $0.centerX.equalTo(stackView)
            $0.centerY.equalTo(profileContainer)
        }

         buttonStack.snp.makeConstraints {
             $0.top.equalTo(stackView.snp.bottom).offset(40)
             $0.leading.trailing.equalToSuperview()
             $0.bottom.equalTo(safeAreaLayoutGuide)
         }

        prevButton.snp.makeConstraints {
            $0.width.equalTo(CGFloat(80).fitWidth)
            $0.height.equalTo(CGFloat(53).fitHeight)
        }

        completeButton.snp.makeConstraints {
            $0.height.equalTo(CGFloat(53).fitHeight)
        }

    }

    func setDelegate() {
    }

    func setDataSource() {
    }

    func setBindings() {
    }

}

