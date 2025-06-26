//
//  GenderSelectionView.swift
//  BestWish
//
//  Created by yimkeul on 6/11/25.
//


import UIKit

import SnapKit
import Then

/// 성벌 션택 화면
final class GenderSelectionView: UIView {

    // MARK: - Private Property
    private let _rootVStackView = VerticalStackView(spacing: 8)
    private let _genderLabel = GroupTitleLabel(title: "성별")
    private let _radioHStackView = HorizontalStackView(spacing: 24)
    private let _maleButton = RadioButton(title: Gender.male.value)
    private let _femaleButton = RadioButton(title: Gender.female.value)
    private let _nothingButton = RadioButton(title: Gender.nothing.value)

    // MARK: - Internal Property
    var maleButton: RadioButton { _maleButton }
    var femaleButton: RadioButton { _femaleButton }
    var nothingButton: RadioButton { _nothingButton }

    init() {
        super.init(frame: .zero)
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 선택한 성별 버튼 이미지 변경
    func configure(genderIndex: Int?) {
        let selectedGender = genderIndex.flatMap(Gender.init)

        let buttons = [maleButton, femaleButton, nothingButton]

        for (genderCase, button) in zip(Gender.allCases, buttons) {
            button.isSelected = (genderCase == selectedGender)
        }
    }
}

// MARK: - private 메서드
private extension GenderSelectionView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        _rootVStackView.do {
            $0.alignment = .leading
        }

        _radioHStackView.do {
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
        self.addSubview(_rootVStackView)
        self._rootVStackView.addArrangedSubviews(_genderLabel, _radioHStackView)
        self._radioHStackView.addArrangedSubviews(_maleButton, _femaleButton, _nothingButton)
    }

    func setConstraints() {
        _rootVStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: Gender
/// 성별 선택 종류
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
