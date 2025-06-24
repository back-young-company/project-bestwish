//
//  OnboardingFirstView.swift
//  BestWish
//
//  Created by yimkeul on 6/11/25.
//

import UIKit

import SnapKit
import Then

/// 온보딩 첫번째 화면
final class OnboardingFirstView: UIView {

    // MARK: - Private Property
    private let _headerView = OnboardingHeaderView(
        current: 1,
        total: 2,
        title: OnboardingText.firstTitle.value,
        desc: OnboardingText.firstDesc.value
    )
    private let _descGengerLabel = UILabel()
    private let _genderBirthVStackView = VerticalStackView(spacing: 32)
    private let _genderSelection = GenderSelectionView()
    private let _birthSelection = BirthSelectionView()
    private let _buttonVStackView = VerticalStackView()
    private let _nextPageButton = AppButton(type: .next)

    // MARK: - Internal Property
    var genderSelection: GenderSelectionView { _genderSelection }
    var birthSelection: BirthSelectionView { _birthSelection }
    var nextPageButton: AppButton { _nextPageButton }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    /// 생년월일 버튼 선택시 테두리 설정
    func configure(isFoucsed: Bool) {
        _birthSelection.dateButton.layer.borderColor = isFoucsed ? UIColor.primary300?.cgColor : UIColor.gray200?.cgColor
    }

    /// 온보딩 첫번째 화면 입력 완료시 설정
    /// 1. (모든 입력 완료시) 다음 버튼 활성화
    /// 2. 성별, 생년월일 화면 표시
    func configure(with userInfo: UserInfoModel?) {
        let isValid = userInfo?.gender != nil && userInfo?.birth != nil
        _nextPageButton.isEnabled = isValid
        _genderSelection.configure(genderIndex: userInfo?.gender)
        _birthSelection.configure(title: userInfo?.birthString)
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

        _descGengerLabel.do {
            $0.text = OnboardingText.firstGender.value
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            $0.font = .font(.pretendardMedium, ofSize: 12)
            $0.textColor = .gray200
        }

        _genderBirthVStackView.do {
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(
                top: 16,
                left: 20,
                bottom: 16,
                right: 20
            )
        }
        _buttonVStackView.do {
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(
                top: 12,
                left: 20,
                bottom: 12,
                right: 20
            )
        }

        _nextPageButton.do {
            $0.isEnabled = false
        }
    }

    func setHierarchy() {
        self.addSubviews(_headerView, _descGengerLabel, _genderBirthVStackView, _buttonVStackView)
        _genderBirthVStackView.addArrangedSubviews(_genderSelection, _birthSelection)
        _buttonVStackView.addArrangedSubview(_nextPageButton)
    }

    func setConstraints() {
        _headerView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(CGFloat(38).fitHeight)
            $0.leading.trailing.equalToSuperview()
        }

        _descGengerLabel.snp.makeConstraints {
            $0.top.equalTo(_headerView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        _genderBirthVStackView.snp.makeConstraints {
            $0.top.equalTo(_descGengerLabel.snp.bottom).offset(CGFloat(22).fitHeight)
            $0.leading.trailing.equalToSuperview()
        }

        _buttonVStackView.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }

        _nextPageButton.snp.makeConstraints {
            $0.height.equalTo(CGFloat(54).fitHeight)
        }
    }
}
