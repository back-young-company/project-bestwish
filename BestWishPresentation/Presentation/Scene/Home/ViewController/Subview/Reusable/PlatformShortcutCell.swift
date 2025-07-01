//
//  PlatformShortcutCell.swift
//  BestWish
//
//  Created by 백래훈 on 6/10/25.
//

import BestWishDomain
import UIKit
import BestWishDomain

internal import Kingfisher
internal import SnapKit
internal import Then

/// 플랫폼 바로가기 Cell
final class PlatformShortcutCell: UICollectionViewCell, ReuseIdentifier {

    // MARK: - Private Property
    private let _platformTitleLabel = UILabel()
    private let _platformImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        _platformImageView.image = nil
    }

  func configure(type: PlatformEntity, isSelected: Bool = false) {
        _platformTitleLabel.text = type.platformName
        _platformImageView.image = UIImage(named: type.platformImage)
        
        backgroundColor = isSelected ? .primary50 : .clear
        layer.cornerRadius = 8
        clipsToBounds = true
        _platformImageView.updateShadowPath()
    }
}

// MARK: - PlatformShortcutCell 설정
private extension PlatformShortcutCell {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        _platformTitleLabel.do {
            $0.textColor = .black
            $0.font = .font(.pretendardMedium, ofSize: 12)
            $0.textAlignment = .center
        }

        _platformImageView.do {
            $0.layer.cornerRadius = 32
            $0.layer.shadowColor = UIColor.gray900?.cgColor
            $0.layer.shadowOpacity = 0.1
            $0.layer.shadowOffset = CGSize(width: 0, height: 0.5)
            $0.layer.shadowRadius = 4
        }
    }

    func setHierarchy() {
        self.contentView.addSubviews(_platformTitleLabel, _platformImageView)
    }

    func setConstraints() {
        _platformImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.horizontalEdges.equalToSuperview().inset(8)
            $0.size.equalTo(64)
        }
        
        _platformTitleLabel.snp.makeConstraints {
            $0.top.equalTo(_platformImageView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().offset(-8)
        }
    }
}
