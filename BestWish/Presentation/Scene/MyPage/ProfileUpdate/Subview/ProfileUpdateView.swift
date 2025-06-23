//
//  ProfileUpdateView.swift
//  BestWish
//
//  Created by 이수현 on 6/10/25.
//

import UIKit

final class ProfileUpdateView: UIView {
    private let profileImageView = UIImageView()
    private let emailStackView = VerticalStackView(spacing: 12)
    private let emailLabel = GroupTitleLabel(title: "이메일")
    private let emailValueLabel = PaddingLabel(top: 0, left: 10, bottom: 0, right: 0)
    private let nicknameStackView = VerticalStackView(spacing: 12)
    private let nicknameLabel = GroupTitleLabel(title: "닉네임")
    private let nicknameTextField = UITextField()
    private let confirmChangeButton = AppButton(type: .confirmChange)
    private let cautionLabel = CautionLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(user: UserInfoModel) {
        emailValueLabel.text = user.email
        profileImageView.image = UIImage(named: user.profileImageName)
        nicknameTextField.text = user.nickname
    }

    func configure(isValidNickname: Bool) {
        confirmChangeButton.isEnabled = isValidNickname
        cautionLabel.isHidden = isValidNickname
    }

    func addUnderLine() {
        nicknameTextField.addUnderLine()
    }

    var getProfileImageView: UIImageView { profileImageView }
    var getConfirmButton: AppButton { confirmChangeButton }
    var getNicknameTextField: UITextField { nicknameTextField }
}

private extension ProfileUpdateView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        self.backgroundColor = .gray0
        profileImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.layer.cornerRadius = CGFloat(88).fitWidth / 2
            $0.clipsToBounds = true
            $0.isUserInteractionEnabled = true
        }

        emailValueLabel.do {
            $0.backgroundColor = .gray50
            $0.textColor = .gray200
            $0.font = .font(.pretendardBold, ofSize: 16)
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }

        nicknameTextField.do {
            $0.placeholder = "닉네임을 입력해주세요."
            $0.textColor = .gray900
            $0.font = .font(.pretendardBold, ofSize: 16)
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
            $0.leftViewMode = .always
        }

        cautionLabel.do {
            $0.isHidden = true
            $0.textColor = .red0
        }
    }

    func setHierarchy() {
        self.addSubviews(
            profileImageView,
            emailStackView,
            nicknameStackView,
            confirmChangeButton
        )
        emailStackView.addArrangedSubviews(
            emailLabel,
            emailValueLabel
        )
        nicknameStackView.addArrangedSubviews(
            nicknameLabel,
            nicknameTextField,
            cautionLabel
        )
    }

    func setConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(28)
            make.size.equalTo(CGFloat(88).fitWidth)
            make.centerX.equalToSuperview()
        }

        emailStackView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(36)
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
        }

        emailValueLabel.snp.makeConstraints { make in
            make.height.equalTo(CGFloat(48).fitHeight)
        }

        nicknameStackView.snp.makeConstraints { make in
            make.top.equalTo(emailStackView.snp.bottom).offset(36)
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
        }

        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(CGFloat(48).fitHeight)
        }

        confirmChangeButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(12)
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(54)
        }
    }
}
