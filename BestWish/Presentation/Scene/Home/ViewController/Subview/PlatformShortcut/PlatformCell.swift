//
//  PlatformCell.swift
//  BestWish
//
//  Created by 백래훈 on 6/10/25.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class PlatformCell: UICollectionViewCell, ReuseIdentifier {
    
    private let platformTitleLabel = UILabel()
    private let platformImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        platformImageView.image = nil
    }

    func configure(type: Platform, isSelected: Bool = false) {
        platformTitleLabel.text = type.platformName
        platformImageView.image = UIImage(named: type.platformImage)
        
        backgroundColor = isSelected ? .primary50 : .clear
        layer.cornerRadius = 8
        clipsToBounds = true
    }
}

private extension PlatformCell {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        platformTitleLabel.do {
            $0.textColor = .black
            $0.font = .font(.pretendardMedium, ofSize: 12)
            $0.textAlignment = .center
        }

        platformImageView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 32
        }
    }

    func setHierarchy() {
        self.contentView.addSubviews(platformTitleLabel, platformImageView)
    }

    func setConstraints() {
        platformImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.horizontalEdges.equalToSuperview().inset(8)
            $0.size.equalTo(64)
        }
        
        platformTitleLabel.snp.makeConstraints {
            $0.top.equalTo(platformImageView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().offset(-8)
        }
    }
}
