//
//  ProfileUpdateView.swift
//  BestWish
//
//  Created by 이수현 on 6/10/25.
//

import UIKit

import SnapKit
import Then

/// 프로필 업데이트 뷰 (이메일, 닉네임)
final class ProfileUpdateView: UIView {

    // MARK: - Private Property
    private let _profileImageView = UIImageView()
    private let _emailStackView = VerticalStackView(spacing: 12)
    private let _emailLabel = GroupTitleLabel(title: "이메일")
    private let _emailValueLabel = PaddingLabel(top: 0, left: 10, bottom: 0, right: 0)
    private let _nicknameStackView = VerticalStackView(spacing: 12)
    private let _nicknameLabel = GroupTitleLabel(title: "닉네임")
    private let _nicknameTextField = UITextField()
    private let _confirmChangeButton = AppButton(type: .confirmChange)
    private let _cautionLabel = CautionLabel()

    // MARK: - Internal Property
    var profileImageView: UIImageView { _profileImageView }
    var confirmButton: AppButton { _confirmChangeButton }
    var nicknameTextField: UITextField { _nicknameTextField }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    /// 유저 정보 데이터 Configure
    func configure(user: UserInfoModel) {
        _emailValueLabel.text = user.email
        _profileImageView.image = UIImage(named: user.profileImageName)
        _nicknameTextField.text = user.nickname
    }

    /// 유효한 닉네임 Configure
    func configure(isValidNickname: Bool) {
        _confirmChangeButton.isEnabled = isValidNickname
        _cautionLabel.isHidden = isValidNickname
    }

    /// 뷰에 UnderLine 추가 메서드
    func addUnderLine() {
        _nicknameTextField.addUnderLine()
    }
}

// MARK: - View 설정
private extension ProfileUpdateView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        self.backgroundColor = .gray0
        _profileImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.layer.cornerRadius = CGFloat(88).fitWidth / 2
            $0.clipsToBounds = true
            $0.isUserInteractionEnabled = true
        }

        _emailValueLabel.do {
            $0.backgroundColor = .gray50
            $0.textColor = .gray200
            $0.font = .font(.pretendardBold, ofSize: 16)
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }

        _nicknameTextField.do {
            $0.placeholder = "닉네임을 입력해주세요."
            $0.textColor = .gray900
            $0.font = .font(.pretendardBold, ofSize: 16)
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
            $0.leftViewMode = .always
        }

        _cautionLabel.do {
            $0.isHidden = true
            $0.textColor = .red0
        }
    }

    func setHierarchy() {
        self.addSubviews(
            _profileImageView,
            _emailStackView,
            _nicknameStackView,
            _confirmChangeButton
        )
        _emailStackView.addArrangedSubviews(
            _emailLabel,
            _emailValueLabel
        )
        _nicknameStackView.addArrangedSubviews(
            _nicknameLabel,
            _nicknameTextField,
            _cautionLabel
        )
    }

    func setConstraints() {
        _profileImageView.snp.makeConstraints { 
            $0.top.equalTo(safeAreaLayoutGuide).offset(28)
            $0.size.equalTo(CGFloat(88).fitWidth)
            $0.centerX.equalToSuperview()
        }

        _emailStackView.snp.makeConstraints { 
            $0.top.equalTo(_profileImageView.snp.bottom).offset(36)
            $0.directionalHorizontalEdges.equalToSuperview().inset(20)
        }

        _emailValueLabel.snp.makeConstraints { 
            $0.height.equalTo(CGFloat(48).fitHeight)
        }

        _nicknameStackView.snp.makeConstraints { 
            $0.top.equalTo(_emailStackView.snp.bottom).offset(36)
            $0.directionalHorizontalEdges.equalToSuperview().inset(20)
        }

        _nicknameTextField.snp.makeConstraints { 
            $0.height.equalTo(CGFloat(48).fitHeight)
        }

        _confirmChangeButton.snp.makeConstraints { 
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(12)
            $0.directionalHorizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(CGFloat(54))
        }
    }
}
