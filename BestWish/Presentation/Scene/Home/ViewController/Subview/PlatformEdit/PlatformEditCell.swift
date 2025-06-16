//
//  PlatformEditCell.swift
//  BestWish
//
//  Created by 백래훈 on 6/12/25.
//

import UIKit

import SnapKit
import Then

final class PlatformEditCell: UITableViewCell, ReuseIdentifier {
    
    private let platformImageView = UIImageView()
    private let platformTitleLabel = UILabel()
    private let platformCountLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.separatorInset = .zero
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    func configure(type: PlatformEdit) {
        platformTitleLabel.text = type.platformName
        platformImageView.image = UIImage(named: type.platformImage)
        platformCountLabel.text = "\(type.platformCount)"
        
        platformImageView.updateShadowPath()
    }
}

private extension PlatformEditCell {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        platformImageView.do {
            $0.layer.masksToBounds = false  // ✅ 꼭 필요
            $0.layer.cornerRadius = 32
            $0.layer.shadowColor = UIColor.gray900?.cgColor
            $0.layer.shadowOpacity = 0.1
            $0.layer.shadowOffset = CGSize(width: 0, height: 0.5)
            $0.layer.shadowRadius = 4
        }
        
        platformTitleLabel.do {
            $0.textColor = .gray800
            $0.font = .font(.pretendardMedium, ofSize: 14)
        }

        platformCountLabel.do {
            $0.textColor = .gray200
            $0.font = .font(.pretendardMedium, ofSize: 14)
        }
    }

    func setHierarchy() {
        self.contentView.addSubviews(platformImageView, platformTitleLabel, platformCountLabel)
    }

    func setConstraints() {
        platformImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-8)
            $0.size.equalTo(64)
        }
        
        platformTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(platformImageView)
            $0.leading.equalTo(platformImageView.snp.trailing).offset(8)
        }
        
        platformCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(platformTitleLabel)
            $0.leading.equalTo(platformTitleLabel.snp.trailing).offset(8)
        }
    }
}
