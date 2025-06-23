//
//  MyPageRowView.swift
//  BestWish
//
//  Created by 이수현 on 6/11/25.
//

import UIKit

import SnapKit
import Then

/// 마이페이지 셀 뷰
final class MyPageRowView: UIStackView {
    private let type: StackViewType
    private let title: String
    private let subTitle: String

    // MARK: - Private Property
    private let _titleLabel = UILabel()
    private let _arrowButton = UIButton()

    // MARK: - Internal Property
    var arrowButton: UIButton { _arrowButton }

    init(type: StackViewType, title: String, subTitle: String = "") {
        self.type = type
        self.title = title
        self.subTitle = subTitle
        super.init(frame: .zero)

        setView()
    }

    required init(coder: NSCoder) {
        fatalError()
    }

    func configure(title: String) {
        _titleLabel.text = title
    }
}

// MARK: - View 설정
private extension MyPageRowView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        self.axis = .horizontal
        self.distribution = .fill

        _titleLabel.do {
            $0.text = title
            $0.textColor = type.titleColor
            $0.font = type.titleFont
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        }

        _arrowButton.do {
            var config = UIButton.Configuration.plain()
            config.baseForegroundColor = .gray200
            config.attributedTitle = AttributedString(subTitle, attributes: AttributeContainer([
                .font: UIFont.font(.pretendardMedium, ofSize: 14)
            ]))
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 10)
            config.preferredSymbolConfigurationForImage = symbolConfig
            let image: UIImage? = .init(systemName: "chevron.right")
            config.image = type.isHiddenButtonImage ? image : nil
            config.imagePlacement = .trailing
            config.imagePadding = 13.25

            $0.configuration = config
            $0.isHidden = type.isHiddenButton
            $0.isEnabled = type.isEnabledButton
            $0.setContentHuggingPriority(.required, for: .horizontal)
        }
    }

    func setHierarchy() {
        self.addArrangedSubviews(_titleLabel, _arrowButton)
    }

    func setConstraints() {
        _titleLabel.snp.makeConstraints { make in
            make.height.equalTo(43)
        }
    }
}

// MARK: - MyPageRowView: StackViewType 타입 정의
extension MyPageRowView {

    /// StackViewType
    /// example: title + subTitle + > 버튼
    enum StackViewType {
        case minimal    // title만
        case button     // title + > 버튼
        case subTitle   // title + subTitle
        case maximum    // title + subTitle + > 버튼
        case logout     // 로그아웃
    }
}

// MARK: - MyPageRowView: StackViewType 타입 프로퍼티 정의
extension MyPageRowView.StackViewType {
    var isHiddenSubTitle: Bool {
        switch self {
        case .minimal, .button: true
        default: false
        }
    }

    var isHiddenButton: Bool {
        switch self {
        case .minimal: true
        default: false
        }
    }

    var isHiddenButtonImage: Bool {
        switch self {
        case .subTitle, .logout: false
        default: true
        }
    }

    var isEnabledButton: Bool {
        switch self {
        case .subTitle: false
        default: true
        }
    }

    var titleColor: UIColor? {
        switch self {
        case .logout: .gray200
        default: .black
        }
    }

    var titleFont: UIFont? {
        switch self {
        case .logout: .font(.pretendardMedium, ofSize: 14)
        default: .font(.pretendardMedium, ofSize: 16)
        }
    }
}
