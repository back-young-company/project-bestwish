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

    // MARK: - UI Components

    // MARK: - Initializer, Deinit, requiered
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

    // MARK: - Attirbute Helper
    // View에 대한 속성 설정 메서드
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
    
    // MARK: - Hierarchy Helper
    // subView 추가 메서드
    func setHierarchy() {
        self.addSubviews(loginLogoImageView, kakaoLoginButton, appleLoginButton)
    }

    // MARK: - Layout Helper
    // 오토레이이아웃 설정 메서드
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

    // MARK: - Delegate Helper
    // 딜리게이트 설정
    func setDelegate() {
    }

    // MARK: - DataSource Helper
    // 데이터 소스 설정
    func setDataSource() {
    }

    // MARK: - Binding Helper
    func setBindings() {

    }
}
