//
//  BirthSelectionView.swift
//  BestWish
//
//  Created by yimkeul on 6/11/25.
//

import UIKit

import SnapKit
import Then

/// 생년월일 선택 화면
final class BirthSelectionView: UIView {

    // MARK: - Private Property
    private let _rootVStackView = VerticalStackView(spacing: 8)
    private let _birthLabel = GroupTitleLabel(title: "생년월일")
    private let _dateButton = UIButton()

    // MARK: - Internal Property
    var dateButton: UIButton { _dateButton }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    /// 생년월일 선택 버튼에 선택한 날짜 표기 설정
    func configure(title: String?) {
        dateButton.setTitle(title, for: .normal)
    }
}

// MARK: - private 메서드
private extension BirthSelectionView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        _dateButton.do {
            var config = UIButton.Configuration.plain()
            config.contentInsets = .init(top: 0, leading: 12, bottom: 0, trailing: 12)
            config.titleTextAttributesTransformer =
                UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = .font(.pretendardMedium, ofSize: 16)
                return outgoing
            }
            config.titleLineBreakMode = .byWordWrapping
            config.imagePlacement = .trailing
            config.baseForegroundColor = .gray900
            config.baseBackgroundColor = .gray0
            $0.configuration = config

            $0.contentHorizontalAlignment = .fill
            $0.setTitle(" ", for: .normal)
            $0.setImage(UIImage(named: "calendar"), for: .normal)
            $0.layer.cornerRadius = 8
            $0.layer.borderWidth = 1.5
            $0.layer.borderColor = UIColor.gray200?.cgColor
        }
    }

    func setHierarchy() {
        self.addSubviews(_rootVStackView)
        _rootVStackView.addArrangedSubviews(_birthLabel, dateButton)
    }

    func setConstraints() {
        _rootVStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        _dateButton.snp.makeConstraints {
            $0.height.equalTo(CGFloat(48))
        }
    }
}

