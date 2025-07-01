//
//  PlatformEditCell.swift
//  BestWish
//
//  Created by 백래훈 on 6/12/25.
//

import UIKit

internal import SnapKit
internal import Then

/// 플랫폼 편집 Cell
final class PlatformEditCell: UITableViewCell, ReuseIdentifier {

    // MARK: - Private Property
    private let _platformImageView = UIImageView()
    private let _platformTitleLabel = UILabel()
    private let _platformCountLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(type: PlatformEditItem) {
        _platformTitleLabel.text = type.platformName
        _platformImageView.image = UIImage(named: type.platformImage)
        _platformCountLabel.text = "\(type.platformCount)"
        
        _platformImageView.updateShadowPath()
    }
}

// MARK: - PlatformEditCell 설정
private extension PlatformEditCell {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        self.selectionStyle = .none
        self.separatorInset = .zero

        _platformImageView.do {
            $0.layer.cornerRadius = 32
            $0.layer.shadowColor = UIColor.gray900?.cgColor
            $0.layer.shadowOpacity = 0.1
            $0.layer.shadowOffset = CGSize(width: 0, height: 0.5)
            $0.layer.shadowRadius = 4
        }
        
        _platformTitleLabel.do {
            $0.textColor = .gray800
            $0.font = .font(.pretendardMedium, ofSize: 14)
        }

        _platformCountLabel.do {
            $0.textColor = .gray200
            $0.font = .font(.pretendardMedium, ofSize: 14)
        }
    }

    func setHierarchy() {
        self.contentView.addSubviews(_platformImageView, _platformTitleLabel, _platformCountLabel)
    }

    func setConstraints() {
        _platformImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-8)
            $0.size.equalTo(64)
        }
        
        _platformTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(_platformImageView)
            $0.leading.equalTo(_platformImageView.snp.trailing).offset(8)
        }
        
        _platformCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(_platformTitleLabel)
            $0.leading.equalTo(_platformTitleLabel.snp.trailing).offset(8)
        }
    }
}
