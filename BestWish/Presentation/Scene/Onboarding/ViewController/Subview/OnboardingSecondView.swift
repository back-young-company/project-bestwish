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
    private let headerView = OnboardingHeaderView(current: 2, total: 2,
                                                  title: OnboardingText.secondTitle.value,
                                                  desc: OnboardingText.secondDesc.value)
    private let profileContainer = UIView()
    let profileImageView = UIImageView()

    private let nickName2ButtonStackView = VerticalStackView(spacing: CGFloat(160).fitHeight)
    let nicknameVStackView = NicknameInputView()
    private let buttonHStackView = HorizontalStackView(spacing: CGFloat(12).fitWidth)
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

    func configure(imageName: String?) {
        guard let imageName else { return }
        profileImageView.image = UIImage(named: imageName)?.resize(to: CGSize(width: CGFloat(152).fitHeight, height: CGFloat(152).fitHeight))
    }

    func configure(isValidNickname: Bool) {
        // 버튼 활성화
        completeButton.isEnabled = isValidNickname

        nicknameVStackView.textField.layer.borderColor =
        isValidNickname ? UIColor.primary300?.cgColor : UIColor.red0?.cgColor

        nicknameVStackView.cautionLabel.textColor = isValidNickname ? .gray200 : .red0
    }

}

private extension OnboardingSecondView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        self.backgroundColor = .gray0

        profileImageView.do {
            $0.contentMode = .scaleToFill
            $0.layer.cornerRadius = CGFloat(152).fitHeight / 2
            $0.clipsToBounds = true
            $0.isUserInteractionEnabled = true
        }

        buttonHStackView.do {
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(
                top: 12,
                left: 0,
                bottom: 12,
                right: 0
            )
        }

        completeButton.do {
            $0.isEnabled = false
        }
    }

    func setHierarchy() {

        self.addSubviews(headerView, profileImageView, nickName2ButtonStackView)
        nickName2ButtonStackView.addArrangedSubviews(nicknameVStackView, buttonHStackView)
        buttonHStackView.addArrangedSubviews(prevButton, completeButton)
    }

    func setConstraints() {

        headerView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(CGFloat(38).fitHeight)
            $0.leading.trailing.equalToSuperview()
        }

        profileImageView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(24)
            $0.size.equalTo(CGFloat(152).fitHeight)
            $0.centerX.equalToSuperview()
        }

        nickName2ButtonStackView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(keyboardLayoutGuide.snp.top)
        }


        buttonHStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }

        prevButton.snp.makeConstraints {
            $0.width.equalTo(CGFloat(80).fitWidth)
            $0.height.equalTo(54)
        }

        completeButton.snp.makeConstraints {
            $0.height.equalTo(54)
        }

    }

}

