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
        
    }

    func configure(type: String) {
        let titleFont = UIFont.font(.pretendardBold, ofSize: 14)
        platformButton.configuration?.attributedTitle = AttributedString(type, attributes: AttributeContainer([.font: titleFont]))
        platformButton.sizeToFit()
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
            config.cornerStyle = .capsule
            config.baseForegroundColor = .white
            config.baseBackgroundColor = .primary300
            config.titleLineBreakMode = .byTruncatingTail
            $0.configuration = config
        }
    }

    func setHierarchy() {
        self.contentView.addSubview(platformButton)
    }

    func setConstraints() {
        platformButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(33)
        }
    }
}
