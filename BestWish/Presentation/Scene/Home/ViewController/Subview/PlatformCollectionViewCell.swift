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
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()

        let size = contentView.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )

        var newAttributes = layoutAttributes
        newAttributes.frame.size = size
        return newAttributes
    }

    func configure(type: String) {
        var config = UIButton.Configuration.filled()
        let titleFont = UIFont.font(.pretendardBold, ofSize: 14)
        config.cornerStyle = .capsule
        config.attributedTitle = AttributedString(type, attributes: AttributeContainer([.font: titleFont]))
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .primary200
        platformButton.configuration = config
    }
}

private extension PlatformCollectionViewCell {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
//        platformButton.do {
//            var config = UIButton.Configuration.filled()
//            let titleFont = UIFont.font(.pretendardBold, ofSize: 14)
//            config.cornerStyle = .capsule
//            config.attributedTitle = AttributedString("전체", attributes: AttributeContainer([.font: titleFont]))
//            config.baseForegroundColor = .white
//            config.baseBackgroundColor = .primary200
//            $0.configuration = config
//        }
    }

    func setHierarchy() {
        self.contentView.addSubview(platformButton)
    }

    func setConstraints() {
        platformButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(8)
            $0.width.equalToSuperview()
            $0.height.equalTo(33)
        }
    }
}
