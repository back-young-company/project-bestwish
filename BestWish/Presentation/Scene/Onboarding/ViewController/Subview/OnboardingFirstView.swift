//
//  OnboardingFirstView.swift
//  BestWish
//
//  Created by yimkeul on 6/11/25.
//

import UIKit
import SnapKit
import Then

final class OnboardingFirstView: UIView {

    private let headerView = OnboardingHeaderView(current: 1, total: 2,
                                                  title: OnboardingText.firstTitle.value,
                                                  desc: OnboardingText.firstDesc.value)
    private let genderBirthVStackView = VerticalStackView(spacing: 32)
    let genderSelection = GenderSelectionView()
    let birthSelection = BirthSelectionView()
    private let buttonVStackView = VerticalStackView()
    let nextPageButton = AppButton(type: .next)


    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(_ isValid: Bool) {
        nextPageButton.isEnabled = isValid
    }

}

private extension OnboardingFirstView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        self.backgroundColor = .gray0
        genderBirthVStackView.do {
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(
                top: 16,
                left: 20,
                bottom: 16,
                right: 20
            )
        }
        buttonVStackView.do {
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(
                top: 12,
                left: 20,
                bottom: 12,
                right: 20
            )
        }

        nextPageButton.do {
            $0.isEnabled = false
        }
    }

    func setHierarchy() {
        self.addSubviews(headerView, genderBirthVStackView, buttonVStackView)
        genderBirthVStackView.addArrangedSubviews(genderSelection, birthSelection)
        buttonVStackView.addArrangedSubview(nextPageButton)
    }

    func setConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(CGFloat(38).fitHeight)
            $0.leading.trailing.equalToSuperview()
        }

        genderBirthVStackView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview()
        }

        buttonVStackView.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }

        nextPageButton.snp.makeConstraints {
            $0.height.equalTo(54)
        }
    }
}

