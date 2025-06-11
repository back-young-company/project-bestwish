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

    // MARK: - Properties
    let kakaoLoginButton = UIButton()
    let appleLoginButton = UIButton()
//    ASAuthorizationAppleIDButton(type: .signIn, style: .whiteOutline)

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
        kakaoLoginButton.do {
            $0.setImage(UIImage(named: "kakaoLogin")?.resize(to: CGSize(width: CGFloat(335).fitWidth, height: CGFloat(56).fitHeight)),
                        for: .normal)
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
        }

        appleLoginButton.do {
//            $0.cornerRadius = 12
            $0.setImage(UIImage(named: "kakaoLogin")?.resize(to: CGSize(width: CGFloat(335).fitWidth, height: CGFloat(56).fitHeight)),
                        for: .normal)
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
        }
    }
    // MARK: - Hierarchy Helper
    // subView 추가 메서드
    func setHierarchy() {
        self.addSubviews(kakaoLoginButton, appleLoginButton)
    }

    // MARK: - Layout Helper
    // 오토레이이아웃 설정 메서드
    func setConstraints() {
        kakaoLoginButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        appleLoginButton.snp.makeConstraints {
            $0.top.equalTo(kakaoLoginButton.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(CGFloat(335).fitWidth)
            $0.height.equalTo(CGFloat(56).fitHeight)
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

