//
//  WishlistPlatformCell.swift
//  BestWish
//
//  Created by 백래훈 on 6/11/25.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class WishlistPlatformCell: UICollectionViewCell, ReuseIdentifier {
    
    private let platformButton = UIButton()
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }

    func configure(type: String, isSelected: Bool) {
        let titleFont = UIFont.font(.pretendardBold, ofSize: 14)

        var config = platformButton.configuration ?? UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.titleLineBreakMode = .byTruncatingTail
        config.attributedTitle = AttributedString(type, attributes: AttributeContainer([.font: titleFont]))
        
        config.baseForegroundColor = isSelected ? .gray0 : .gray500
        config.baseBackgroundColor = isSelected ? .primary300 : .gray0
        platformButton.configuration = config

        platformButton.layer.borderWidth = isSelected ? 0 : 1.5
        platformButton.layer.borderColor = isSelected ? nil : UIColor.gray100?.cgColor
        platformButton.layer.cornerRadius = isSelected ? 0 : 16.5
        platformButton.sizeToFit()
    }
    
    var getPlatformButton: UIButton { platformButton }
}

private extension WishlistPlatformCell {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
//        platformButton.do {
//            $0.clipsToBounds = true
//        }
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
