//
//  OnboardingHeaderView.swift
//  BestWish
//
//  Created by yimkeul on 6/11/25.
//

import UIKit
import SnapKit
import Then

final class OnboardingHeaderView: UIView {

    private let infoStackView = VerticalStackView(spacing: 12)
    private let pageInfoLabel: PageInfoView
    private let titleLabel = UILabel()
    private let descLabel = UILabel()

    init(current: Int, total: Int, title: String, desc: String) {
        self.pageInfoLabel = PageInfoView(current: current, total: total)
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
private extension OnboardingHeaderView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        infoStackView.do {
            $0.alignment = .leading
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(
                top: 16,
                left: 20,
                bottom: 16,
                right: 20
            )

        }
        titleLabel.do {
            $0.numberOfLines = 0     
            $0.font = .font(.pretendardBold, ofSize: 24)
            $0.textColor = .gray900
        }
        descLabel.do {
            $0.font = .font(.pretendardMedium, ofSize: 16)
            $0.textColor = .gray600
        }
    }

    func setHierarchy() {
        self.addSubview(infoStackView)
        infoStackView.addArrangedSubviews(pageInfoLabel, titleLabel, descLabel)
    }

    func setConstraints() {
        infoStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

    }
}
