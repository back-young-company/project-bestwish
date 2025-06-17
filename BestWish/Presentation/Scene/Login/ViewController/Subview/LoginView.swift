//
//  LoginView.swift
//  BestWish
//
//  Created by yimkeul on 6/7/25.
//

import UIKit
import SnapKit
import Then
import AuthenticationServices

final class LoginView: UIView {

    private let loginLogoImageView = UIImageView()
    private let buttonVStackView = VerticalStackView(spacing: 12)
    let kakaoLoginButton = UIButton()
    let appleLoginButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

}

private extension LoginView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        self.backgroundColor = .primary300

        loginLogoImageView.do {
            $0.image = UIImage(named: "loginLogo")?.resize(to:
                CGSize(width: CGFloat(375).fitWidth, height: CGFloat(130).fitHeight)
            )
        }

        buttonVStackView.do {
            $0.alignment = .center
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(
                top: 12,
                left: 20,
                bottom: 12,
                right: 20
            )
        }

        kakaoLoginButton.do {
            $0.setImage(UIImage(named: "kakaoLogin"), for: .normal)
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
        }

        appleLoginButton.do {
            $0.setImage(UIImage(named: "appleLogin"), for: .normal)
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
        }
    }

    func setHierarchy() {
        self.addSubviews(loginLogoImageView, buttonVStackView)
        buttonVStackView.addArrangedSubviews(kakaoLoginButton, appleLoginButton)
    }

    func setConstraints() {
        loginLogoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
                .offset(CGFloat(132).fitHeight)
        }

        buttonVStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(CGFloat(110).fitHeight)
        }
    }
}
