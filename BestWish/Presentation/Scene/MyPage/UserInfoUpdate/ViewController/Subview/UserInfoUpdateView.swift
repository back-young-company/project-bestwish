//
//  UserInfoUpdateView.swift
//  BestWish
//
//  Created by 이수현 on 6/12/25.
//

import UIKit

final class UserInfoUpdateView: UIView {
    private let stackView = VerticalStackView(spacing: 32)
    let genderSelection = GenderSelectionView()
    let birthSelection = BirthSelectionView()
    let saveButton = AppButton(type: .save)

    override init(frame: CGRect) {
        super.init(frame: frame)

        setView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(userInfo: OnboardingDisplay) {
        genderSelection.configure(genderIndex: userInfo.gender)
        birthSelection.configure(title: userInfo.birthString)
    }
}

private extension UserInfoUpdateView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        self.backgroundColor = .white

        stackView.do {
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(
                top: 16,
                left: 20,
                bottom: 16,
                right: 20
            )
        }

        birthSelection.do {
            $0.dateButton.layer.borderColor = UIColor.primary300?.cgColor
        }
    }

    func setHierarchy() {
        stackView.addArrangedSubviews(genderSelection, birthSelection)
        addSubviews(stackView, saveButton)
    }

    func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(57)
            make.directionalHorizontalEdges.equalToSuperview()
        }

        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(12)
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(CGFloat(53).fitHeight)
        }
    }
}

