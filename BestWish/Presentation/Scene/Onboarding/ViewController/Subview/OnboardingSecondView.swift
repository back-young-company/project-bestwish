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
    private let scrollView = UIScrollView()
    private let contentView = UIView()
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

        scrollView.do {
            $0.showsVerticalScrollIndicator = false
        }

        stackView.do {
            $0.backgroundColor = .systemPink
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(
                top: 16,
                left: 20,
                bottom: 16,
                right: 20
            )
        }

        profileImageView.do {
            $0.backgroundColor = .blue
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
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubviews(header, stackView, buttonStack)
        stackView.addArrangedSubviews(profileContainer, nicknameStackView)
        profileContainer.addSubview(profileImageView)
        buttonStack.addArrangedSubviews(prevButton, completeButton)

    }

    func setConstraints() {
         scrollView.snp.makeConstraints {
             $0.edges.equalTo(safeAreaLayoutGuide)
         }

         contentView.snp.makeConstraints {
             $0.edges.equalTo(scrollView.contentLayoutGuide)
             $0.width.equalTo(scrollView.frameLayoutGuide)  // 가로 스크롤 방지
         }

         header.snp.makeConstraints {
             $0.top.equalTo(contentView).offset(38)
             $0.leading.trailing.equalTo(contentView)
         }

         stackView.snp.makeConstraints {
             $0.top.equalTo(header.snp.bottom).offset(24)
             $0.leading.trailing.equalTo(contentView)
         }

        profileContainer.snp.makeConstraints {
            $0.height.equalTo(CGFloat(152).fitHeight)
        }

        profileImageView.snp.makeConstraints {
            $0.height.equalTo(CGFloat(152).fitWidth)
            $0.centerX.equalTo(stackView)
            $0.centerY.equalTo(profileContainer)
        }

         buttonStack.snp.makeConstraints {
             $0.top.equalTo(stackView.snp.bottom).offset(40)
             $0.leading.trailing.equalTo(contentView)
             $0.bottom.equalTo(contentView).inset(20)   // 컨텐츠 끝을 고정
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

