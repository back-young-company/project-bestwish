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

    // MARK: - UI Components
    private let header = OnboardingHeaderView(current: 1, total: 2, title: OnboardingText.firstTitle.value, desc: OnboardingText.firstDesc.value)
    private let stackView = VerticalStackView(spacing: 32)
    let genderSelection = GenderSelectionView()
    let birthSelection = BirthSelectionView()
    let nextPageButton = AppButton(type: .nextUnable)


    // MARK: - Initializer, Deinit, requiered
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(_ isValid: Bool) {
        nextPageButton.updateStyle(isValid ? .next : .nextUnable)
    }

}

private extension OnboardingFirstView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    // MARK: - Attirbute Helper
    // View에 대한 속성 설정 메서드
    func setAttributes() {
        self.backgroundColor = .gray0
        stackView.do {
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(
                top: 16,
                left: 20,
                bottom: 16,
                right: 20
            )
        }

        nextPageButton.do {
            $0.isEnabled = false
        }
    }

    func setHierarchy() {
        self.addSubviews(header, stackView, nextPageButton)
        stackView.addArrangedSubviews(genderSelection, birthSelection)
    }

    func setConstraints() {
        header.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(CGFloat(38).fitHeight)
            $0.leading.trailing.equalToSuperview()
        }

        stackView.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview()
        }

        nextPageButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(CGFloat(53).fitHeight)
        }
    }
}

