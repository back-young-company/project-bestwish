//
//  AlertView.swift
//  BestWish
//
//  Created by 이수현 on 6/12/25.
//

import UIKit
import RxSwift

final class AlertView: UIView {
    private let type: AlertType

    private let _contentView = UIView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let buttonStackView = UIStackView()
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

        titleLabel.do {
            $0.text = type.title
            $0.textColor = .gray800
            $0.font = .font(.pretendardBold, ofSize: 18)
            $0.textAlignment = .center
        }

        subTitleLabel.do {
            $0.text = type.subTitle
            $0.textColor = .gray600
            $0.font = .font(.pretendardMedium, ofSize: 12)
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }

        buttonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 12
            $0.distribution = .fillEqually
        }
    }

    func setHierarchy() {
        self.addSubviews(_contentView)
        _contentView.addSubviews(titleLabel, subTitleLabel, buttonStackView)
        buttonStackView.addArrangedSubviews(_cancelButton, _confirmButton)
    }

    func setConstraints() {
        _contentView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(type.titleTopPadding)
            make.directionalHorizontalEdges.equalToSuperview()
            make.height.equalTo(35)
        }

        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.directionalHorizontalEdges.equalToSuperview()
        }

        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(24)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(43)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}
