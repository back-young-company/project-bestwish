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

    private let stackView = VerticalStackView(spacing: 12)
    private let pageInfoLabel: PageInfoView
    private let infoStackView: InfoStackView
    private let titleLabel = UILabel()
    private let descLabel = UILabel()

    init(current: Int, total: Int, title: String, desc: String) {
        self.pageInfoLabel = PageInfoView(current: current, total: total)
        self.infoStackView = InfoStackView(title: title, desc: desc)
        super.init(frame: .zero)
        setView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension OnboardingHeaderView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        stackView.do {
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
        self.addSubview(stackView)
        stackView.addArrangedSubviews(pageInfoLabel, infoStackView)
    }

    func setConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        pageInfoLabel.snp.makeConstraints {
            $0.height.equalTo(CGFloat(19).fitHeight)
        }

    }
}
