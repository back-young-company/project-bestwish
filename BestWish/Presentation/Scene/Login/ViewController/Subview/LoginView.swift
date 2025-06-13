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
        setDelegate()
        setDataSource()
        setBindings()
    }

    func setAttributes() {
        self.backgroundColor = .primary300

        loginLogoImageView.do {
            $0.image = UIImage(named: "loginLogo")?.resize(to: CGSize(width: CGFloat(375).fitWidth, height: CGFloat(130).fitHeight))
        }

        kakaoLoginButton.do {
            $0.setImage(UIImage(named: "kakaoLogin")?.resize(to: CGSize(width: CGFloat(335).fitWidth, height: CGFloat(56).fitHeight)),
                        for: .normal)
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
        }

        appleLoginButton.do {
            $0.setImage(UIImage(named: "appleLogin")?.resize(to: CGSize(width: CGFloat(335).fitWidth, height: CGFloat(56).fitHeight)),
                        for: .normal)
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
        }
    }
    
    func setHierarchy() {
        self.addSubviews(loginLogoImageView, kakaoLoginButton, appleLoginButton)
    }

    func setConstraints() {
        loginLogoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(CGFloat(132).fitHeight)
        }

        kakaoLoginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(loginLogoImageView.snp.bottom).offset(CGFloat(226).fitHeight)
        }
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(kakaoLoginButton.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
    }

    func setDelegate() {
    }

    func setDataSource() {
    }

    func setBindings() {

    }
}
