//
//  AlertView.swift
//  BestWish
//
//  Created by 이수현 on 6/12/25.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class AlertView: UIView {
    private let type: AlertType

    private let _contentView = UIView()
    private let _titleLabel = UILabel()
    private let _subTitleLabel = UILabel()
    private let _buttonStackView = UIStackView()
    private let _cancelButton: AppButton
    private let _confirmButton: AppButton

    var contentView: UIView { _contentView }
    var cancelButton: AppButton { _cancelButton }
    var confirmButton: AppButton { _confirmButton }

    init(type: AlertType) {
        self.type = type
        _cancelButton = AppButton(type: type.cancelButtonType, fontSize: 16)
        _confirmButton = AppButton(type: type.confirmButtonType, fontSize: 16)

        super.init(frame: .zero)

        setView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}

private extension AlertView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        self.backgroundColor = .black.withAlphaComponent(0.5)

        _contentView.do {
            $0.backgroundColor = .gray0
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }

        _titleLabel.do {
            $0.text = type.title
            $0.textColor = .gray800
            $0.font = .font(.pretendardBold, ofSize: 18)
            $0.textAlignment = .center
        }

        _subTitleLabel.do {
            $0.text = type.subTitle
            $0.textColor = .gray600
            $0.font = .font(.pretendardMedium, ofSize: 12)
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }

        _buttonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 12
            $0.distribution = .fillEqually
        }
    }

    func setHierarchy() {
        self.addSubviews(_contentView)
        _contentView.addSubviews(_titleLabel, _subTitleLabel, _buttonStackView)
        _buttonStackView.addArrangedSubviews(_cancelButton, _confirmButton)
    }

    func setConstraints() {
        _contentView.snp.makeConstraints { 
            $0.centerY.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview().inset(20)
        }

        _titleLabel.snp.makeConstraints { 
            $0.top.equalToSuperview().inset(type.titleTopPadding)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(35)
        }

        _subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(_titleLabel.snp.bottom).offset(4)
            $0.directionalHorizontalEdges.equalToSuperview()
        }

        _buttonStackView.snp.makeConstraints {
            $0.top.equalTo(_subTitleLabel.snp.bottom).offset(24)
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(43)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}
