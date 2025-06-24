//
//  GenderSelectionView.swift
//  BestWish
//
//  Created by yimkeul on 6/11/25.
//


import UIKit

enum Gender: Int, CaseIterable {
    case male, female, nothing
    var value: String {
        switch self {
        case .male: return "남자"
        case .female: return "여자"
        case .nothing: return "선택 안 함"
        }
    }
}

final class GenderSelectionView: UIView {

    private let rootVStackView = VerticalStackView(spacing: 8)
    private let genderLabel = GroupTitleLabel(title: "성별")
    private let radioHStackView = HorizontalStackView(spacing: 24)
    let maleButton = RadioButton(title: Gender.male.value)
    let femaleButton = RadioButton(title: Gender.female.value)
    let nothingButton = RadioButton(title: Gender.nothing.value)

    init() {
        super.init(frame: .zero)
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(genderIndex: Int?) {
        let selectedGender = genderIndex.flatMap(Gender.init)

        let buttons = [maleButton, femaleButton, nothingButton]
        for (genderCase, button) in zip(Gender.allCases, buttons) {
            button.isSelected = (genderCase == selectedGender)
        }
    }
}
extension GenderSelectionView {

    private func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        rootVStackView.do {
            $0.alignment = .leading
        }

        radioHStackView.do {
            $0.distribution = .fillProportionally
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(
                top: 12,
                left: 0,
                bottom: 12,
                right: 0
            )
        }
    }

    func setHierarchy() {
        self.addSubview(rootVStackView)
        self.rootVStackView.addArrangedSubviews(genderLabel, radioHStackView)
        self.radioHStackView.addArrangedSubviews(maleButton, femaleButton, nothingButton)
    }

    func setConstraints() {
        rootVStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
