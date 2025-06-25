//
//  WishListFilterCell.swift
//  BestWish
//
//  Created by 백래훈 on 6/11/25.
//

import UIKit

import RxSwift
import SnapKit
import Then

/// 위시리스트 필터 Cell
final class WishListFilterCell: UICollectionViewCell, ReuseIdentifier {

    // MARK: Private Property
    private let _platformButton = UIButton()
    private var _disposeBag = DisposeBag()

    // MARK: Internal Property
    var platformButton: UIButton { _platformButton }
    var disposeBag: DisposeBag { _disposeBag }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        _disposeBag = DisposeBag()
    }

    func configure(type: Int, isSelected: Bool) {
        let titleFont = UIFont.font(.pretendardBold, ofSize: 14)

        var config = _platformButton.configuration ?? UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.titleLineBreakMode = .byTruncatingTail
        config.attributedTitle = AttributedString(PlatformEntity.allCases[type].platformName, attributes: AttributeContainer([.font: titleFont]))
        
        config.baseForegroundColor = isSelected ? .gray0 : .gray500
        config.baseBackgroundColor = isSelected ? .primary300 : .gray0
        _platformButton.configuration = config

        _platformButton.layer.borderWidth = isSelected ? 0 : 1.5
        _platformButton.layer.borderColor = isSelected ? nil : UIColor.gray100?.cgColor
        _platformButton.layer.cornerRadius = isSelected ? 0 : 16.5
        _platformButton.sizeToFit()
    }
}

// MARK: - WishListFilterCell 설정
private extension WishListFilterCell {
    func setView() {
        setHierarchy()
        setConstraints()
    }

    func setHierarchy() {
        self.contentView.addSubview(_platformButton)
    }

    func setConstraints() {
        _platformButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(33)
        }
    }
}
