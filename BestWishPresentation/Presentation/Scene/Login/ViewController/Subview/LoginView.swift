//
//  LoginView.swift
//  BestWish
//
//  Created by yimkeul on 6/7/25.
//

import AuthenticationServices
import UIKit

internal import SnapKit
internal import Then

/// 로그인 화면
final class LoginView: UIView {

    // MARK: - Private Property
    private let _loginLogoImageView = UIImageView()
    private let _buttonVStackView = VerticalStackView(spacing: 12)
    private let _kakaoLoginButton = UIButton()
    private let _appleLoginButton = UIButton()

    // MARK: - Internal Property
    var kakaoLoginButton: UIButton { _kakaoLoginButton }
    var appleLoginButton: UIButton { _appleLoginButton }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

}

// MARK: - private 메서드
private extension LoginView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        self.backgroundColor = .primary300

        _loginLogoImageView.do {
            $0.image = UIImage(named: "loginLogo")?
                .resize(to:CGSize(width: CGFloat(375).fitWidth, height: CGFloat(130).fitHeight))
        }

        _buttonVStackView.do {
            $0.alignment = .center
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(
                top: 12,
                left: 20,
                bottom: 12,
                right: 20
            )
        }

        _kakaoLoginButton.do {
            $0.setImage(UIImage(named: "kakaoLogin"), for: .normal)
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
        }

        _appleLoginButton.do {
            $0.setImage(UIImage(named: "appleLogin"), for: .normal)
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
        }
    }

    func setHierarchy() {
        self.addSubviews(_loginLogoImageView, _buttonVStackView)
        _buttonVStackView.addArrangedSubviews(_kakaoLoginButton, _appleLoginButton)
    }

    func setConstraints() {
        _loginLogoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
                .offset(CGFloat(132).fitHeight)
        }

        _buttonVStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(CGFloat(110).fitHeight)
        }
    }
}
