//
//  WishListEmptyCell.swift
//  BestWish
//
//  Created by 백래훈 on 6/12/25.
//

import UIKit

import RxSwift
import SnapKit
import Then

/// 빈 위시리스트 Cell
final class WishListEmptyCell: UICollectionViewCell, ReuseIdentifier {

    // MARK: - Private Property
    private let _emptyImageView = UIImageView()
    private let _titleLabel = UILabel()
    private let _descriptionLabel = UILabel()
    private let _linkButton = UIButton()
    private var _disposeBag = DisposeBag()

    // MARK: - Internal Property
    var linkButton: UIButton { _linkButton }
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
}

// MARK: - WishListEmptyCell 설정
private extension WishListEmptyCell {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }
    
    func setAttributes() {
        _emptyImageView.do {
            $0.image = UIImage(named: "no_product")
            $0.contentMode = .scaleAspectFit
        }
        
        _titleLabel.do {
            $0.text = "위시리스트가 텅 비었어요!"
            $0.textColor = .gray900
            $0.font = .font(.pretendardBold, ofSize: 20)
        }
        
        _descriptionLabel.do {
            $0.text = "위시리스트를 추가해\n상품을 모아보세요!"
            $0.textColor = .gray400
            $0.font = .font(.pretendardMedium, ofSize: 16)
            $0.numberOfLines = 0
        }
        
        _linkButton.do {
            var config = UIButton.Configuration.plain()
            let titleFont = UIFont.font(.pretendardBold, ofSize: 14)

            config.attributedTitle = AttributedString("링크 저장", attributes: AttributeContainer([.font: titleFont]))
            config.baseForegroundColor = .primary200
            config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
            $0.configuration = config
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.primary200?.cgColor
            $0.layer.borderWidth = 1.5
            $0.clipsToBounds = true
        }
    }
    
    func setHierarchy() {
        self.contentView.addSubviews(_emptyImageView, _titleLabel, _descriptionLabel, _linkButton)
    }
    
    func setConstraints() {
        _emptyImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.size.equalToSuperview().multipliedBy(0.4)
        }
        
        _titleLabel.snp.makeConstraints {
            $0.top.equalTo(_emptyImageView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        _descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(_titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        _linkButton.snp.makeConstraints {
            $0.top.equalTo(_descriptionLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(108)
            $0.height.equalTo(33)
            $0.bottom.equalTo(-100)
        }
    }
}
