//
//  InfoStackView.swift
//  BestWish
//
//  Created by yimkeul on 6/16/25.
//

import UIKit
import SnapKit
import Then

final class InfoStackView: UIView {

    private let stackView = VerticalStackView(spacing: 12)
    private let titleLabel = UILabel()
    private let descLabel = UILabel()

    init(title: String, desc: String) {
        super.init(frame: .zero)
        setView()
        configure(title: title, desc: desc)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(title: String, desc: String) {
        titleLabel.text = title
        descLabel.text = desc
    }
}
private extension InfoStackView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        titleLabel.do {
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            $0.font = .font(.pretendardBold, ofSize: 24)
            $0.textColor = .gray900
        }
        descLabel.do {
            $0.font = .font(.pretendardMedium, ofSize: 16)
            $0.textColor = .gray600
        }
    }

    func setHierarchy() {
        self.addSubview(stackView)
        stackView.addArrangedSubviews(titleLabel, descLabel)
    }

    func setConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(CGFloat(29).fitHeight)
        }

        descLabel.snp.makeConstraints {
            $0.height.equalTo(CGFloat(19).fitHeight)
        }

    }
}
