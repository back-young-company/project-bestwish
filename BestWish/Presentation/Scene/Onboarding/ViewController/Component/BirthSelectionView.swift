//
//  BirthSelectionView.swift
//  BestWish
//
//  Created by yimkeul on 6/11/25.
//

import UIKit
import SnapKit
import Then

final class BirthSelectionView: UIView {

    private let stackView = VerticalStackView(spacing: 8)
    private let birthLabel = InfoLabel(title: "생년월일")
    let dateButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(title: String?) {
        dateButton.setTitle(title, for: .normal)
    }
}

private extension BirthSelectionView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        dateButton.do {
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
        self.addSubviews(stackView)
        stackView.addArrangedSubviews(birthLabel, dateButton)

    }

    func setConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        dateButton.snp.makeConstraints {
            $0.height.equalTo(CGFloat(48).fitHeight)

        }
    }
}

