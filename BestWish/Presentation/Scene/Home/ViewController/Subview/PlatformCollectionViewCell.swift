//
//  PlatformCollectionViewCell.swift
//  BestWish
//
//  Created by 백래훈 on 6/11/25.
//

import UIKit

import SnapKit
import Then

final class PlatformCollectionViewCell: UICollectionViewCell, ReuseIdentifier {
    
    private let platformButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        platformButton.configuration = nil
    }

    func configure(type: String) {
        let titleFont = UIFont.font(.pretendardBold, ofSize: 14)
        platformButton.configuration?.attributedTitle = AttributedString(type, attributes: AttributeContainer([.font: titleFont]))
    }
}

private extension PlatformCollectionViewCell {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        platformButton.do {
            var config = UIButton.Configuration.filled()
//            let titleFont = UIFont.font(.pretendardBold, ofSize: 14)
            config.cornerStyle = .capsule
//            config.attributedTitle = AttributedString("전체", attributes: AttributeContainer([.font: titleFont]))
            config.baseForegroundColor = .white
            config.baseBackgroundColor = .primary300
            $0.configuration = config
        }
    }

    func setHierarchy() {
        self.contentView.addSubview(platformButton)
    }

    func setConstraints() {
        platformButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(8)
            $0.horizontalEdges.equalToSuperview()
//            $0.leading.equalToSuperview()
//            $0.trailing.lessThanOrEqualToSuperview()
            $0.height.equalTo(33)
        }
    }
}
