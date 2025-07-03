//
//  UserInfoUpdateView.swift
//  BestWish
//
//  Created by 이수현 on 6/12/25.
//

import UIKit

internal import SnapKit
internal import Then

/// 유저 정보 업데이트 뷰
final class UserInfoUpdateView: UIView {

    // MARK: - Private Property
    private let _stackView = VerticalStackView(spacing: 32)
    private let _genderSelection = GenderSelectionView()
    private let _birthSelection = BirthSelectionView()
    private let _saveButton = AppButton(type: .save)

    // MARK: - Internal Property
    var genderSelection: GenderSelectionView { _genderSelection }
    var birthSelection: BirthSelectionView { _birthSelection }
    var saveButton: AppButton { _saveButton }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(userInfo: UserInfoModel) {
        _genderSelection.configure(genderIndex: userInfo.gender)
        _birthSelection.configure(title: userInfo.birthString)
    }
}

// MARK: - View 설정
private extension UserInfoUpdateView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        self.backgroundColor = .gray0

        _stackView.do {
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(
                top: 16,
                left: 20,
                bottom: 16,
                right: 20
            )
        }

        _birthSelection.do {
            $0.dateButton.layer.borderColor = UIColor.primary300?.cgColor
        }
    }

    func setHierarchy() {
        _stackView.addArrangedSubviews(_genderSelection, _birthSelection)
        addSubviews(_stackView, _saveButton)
    }

    func setConstraints() {
        _stackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(57)
            $0.directionalHorizontalEdges.equalToSuperview()
        }

        _saveButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(12)
            $0.directionalHorizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(CGFloat(53).fitHeight)
        }
    }
}

