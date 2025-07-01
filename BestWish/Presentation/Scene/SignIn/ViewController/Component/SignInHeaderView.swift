//
//  SignInHeaderView.swift
//  BestWish
//
//  Created by yimkeul on 6/11/25.
//

import UIKit

/// 회원가입 헤더 영역
final class SignInHeaderView: UIView {

    private let _rootVStackView = VerticalStackView(spacing: 12)
    private let _pageInfoLabel: PageInfoView
    private let _infoStackView: IntroTextStackView
    private let _titleLabel = UILabel()
    private let _descLabel = UILabel()

    init(current: Int, total: Int, title: String, desc: String) {
        self._pageInfoLabel = PageInfoView(current: current, total: total)
        self._infoStackView = IntroTextStackView(title: title, desc: desc)
        super.init(frame: .zero)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - private 메서드
private extension SignInHeaderView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        _rootVStackView.do {
            $0.alignment = .leading
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(
                top: 16,
                left: 20,
                bottom: 16,
                right: 20
            )
        }
    }

    func setHierarchy() {
        self.addSubview(_rootVStackView)
        _rootVStackView.addArrangedSubviews(_pageInfoLabel, _infoStackView)
    }

    func setConstraints() {
        _rootVStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        _pageInfoLabel.snp.makeConstraints {
            $0.height.equalTo(CGFloat(19).fitHeight)
        }

        _infoStackView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(CGFloat(60).fitHeight)
        }
    }
}
