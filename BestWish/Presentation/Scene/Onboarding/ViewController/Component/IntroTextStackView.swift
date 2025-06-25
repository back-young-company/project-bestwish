//
//  IntroTextStackView.swift
//  BestWish
//
//  Created by yimkeul on 6/16/25.
//

import UIKit

import SnapKit
import Then

/// 온보딩 헤더뷰 내 텍스트 모음 
final class IntroTextStackView: UIView {

    private let _rootVStackView = VerticalStackView(spacing: 12)
    private let _titleLabel = UILabel()
    private let _descLabel = UILabel()

    init(title: String, desc: String) {
        super.init(frame: .zero)
        setView()
        configure(title: title, desc: desc)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 파라이터로 전달된 정보로 텍스트 설정
    private func configure(title: String, desc: String) {
        _titleLabel.text = title
        _descLabel.text = desc
    }
}

// MARK: - private 메서드
private extension IntroTextStackView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        _rootVStackView.do {
            $0.alignment = .leading
            $0.distribution = .fill
        }

        _titleLabel.do {
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            $0.font = .font(.pretendardBold, ofSize: 24)
            $0.textColor = .gray900
        }
        _descLabel.do {
            $0.font = .font(.pretendardMedium, ofSize: 16)
            $0.textColor = .gray600
        }
    }

    func setHierarchy() {
        self.addSubview(_rootVStackView)
        _rootVStackView.addArrangedSubviews(_titleLabel, _descLabel)
    }

    func setConstraints() {
        _rootVStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        _titleLabel.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(CGFloat(29).fitHeight)
        }

        _descLabel.snp.makeConstraints {
            $0.height.equalTo(CGFloat(19).fitHeight)
        }
    }
}
