//
//  SignInSecondView.swift
//  BestWish
//
//  Created by yimkeul on 6/12/25.
//

import UIKit

import SnapKit
import Then

/// 회원가입 두번째 화면
final class SignInSecondView: UIView {

    // MARK: - Private Property
    private let _headerView = SignInHeaderView(
        current: 2,
        total: 2,
        title: SignInText.secondTitle.value,
        desc: SignInText.secondDesc.value
    )
    private let _profileContainer = UIView()
    private let _profileImageView = UIImageView()
    private let _profileEditImageView = UIImageView()

    private let _nickName2ButtonStackView = VerticalStackView()
    private let _nicknameVStackView = NicknameInputView()
    private let _buttonHStackView = HorizontalStackView(spacing: CGFloat(12).fitWidth)
    private let _prevButton = AppButton(type: .before)
    private let _completeButton = AppButton(type: .complete)

    // MARK: - Internal Property
    var profileImageView: UIImageView { _profileImageView }
    var nicknameVStackView: NicknameInputView { _nicknameVStackView }
    var prevButton: AppButton { _prevButton }
    var completeButton: AppButton { _completeButton }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    /// 프로필 이미지 크기 재설성
    func configure(imageName: String?) {
        guard let imageName else { return }
        _profileImageView.image = UIImage(named: imageName)?
            .resize(
                to: CGSize(
                    width: CGFloat(152).fitHeight,
                    height: CGFloat(152).fitHeight
                )
            )
    }

    /// 회원가입 두번째 화면 입력 완료시 설정
    /// 1. (모든 입력 완료시) 다음 버튼 활성화
    /// 2. 닉네임 버튼 테두리 설정
    /// 3. 닉네임 유효성 검사 안내 텍스트 색상 설정
    func configure(isValidNickname: Bool) {
        _completeButton.isEnabled = isValidNickname
        _nicknameVStackView.textField.layer.borderColor =
            isValidNickname ? UIColor.primary300?.cgColor : UIColor.red0?.cgColor
        _nicknameVStackView.cautionLabel.textColor = isValidNickname ? .gray200 : .red0
    }

}

// MARK: - private 메서드
private extension SignInSecondView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        self.backgroundColor = .gray0

        _profileImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.isUserInteractionEnabled = true
        }

        _profileEditImageView.do {
            $0.image = .profileEdit
            $0.layer.shadowColor = UIColor(hex: "#979797")?.cgColor
            $0.layer.shadowOpacity = 0.2
            $0.layer.shadowRadius = 4
            $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        }

        _nickName2ButtonStackView.do {
            $0.distribution = .equalSpacing
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

        _completeButton.do {
            $0.isEnabled = false
        }
    }

    func setHierarchy() {
        self.addSubviews(_headerView, _profileImageView, _nickName2ButtonStackView)
        _profileImageView.addSubview(_profileEditImageView)
        _nickName2ButtonStackView.addArrangedSubviews(_nicknameVStackView, _buttonHStackView)
        _buttonHStackView.addArrangedSubviews(_prevButton, _completeButton)
    }

    func setConstraints() {
        _headerView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(CGFloat(38).fitHeight)
            $0.leading.trailing.equalToSuperview()
        }

        _profileImageView.snp.makeConstraints {
            $0.top.equalTo(_headerView.snp.bottom).offset(CGFloat(24))
            $0.size.equalTo(CGFloat(152).fitHeight)
            $0.centerX.equalToSuperview()
        }

        _profileEditImageView.snp.makeConstraints {
            $0.size.equalTo(CGFloat(48).fitHeight)
            $0.trailing.bottom.equalToSuperview()
        }

        _nickName2ButtonStackView.snp.makeConstraints {
            $0.top.equalTo(_profileImageView.snp.bottom).offset(CGFloat(40))
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(keyboardLayoutGuide.snp.top)
        }

        _buttonHStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }

        _prevButton.snp.makeConstraints {
            $0.width.equalTo(CGFloat(80).fitWidth)
            $0.height.equalTo(CGFloat(53).fitHeight)
        }

        _completeButton.snp.makeConstraints {
            $0.height.equalTo(CGFloat(53).fitHeight)
        }

    }
}

