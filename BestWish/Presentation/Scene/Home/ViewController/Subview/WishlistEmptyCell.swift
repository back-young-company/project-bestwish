//
//  WishlistEmptyCell.swift
//  BestWish
//
//  Created by 백래훈 on 6/12/25.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class WishlistEmptyCell: UICollectionViewCell, ReuseIdentifier {

    private let emptyImageView = UIImageView()
    private let titleLabel = UILabel()
    private let secondaryLabel = UILabel()
    private let linkButton = UIButton()
    
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
    
    var getLinkButton: UIButton { linkButton }
}

private extension WishlistEmptyCell {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }
    
    func setAttributes() {
        emptyImageView.do {
            $0.image = UIImage(named: "no_product")
            $0.contentMode = .scaleAspectFit
        }
        
        titleLabel.do {
            $0.text = "위시리스트가 텅 비었어요!"
            $0.textColor = .gray900
            $0.font = .font(.pretendardBold, ofSize: 20)
        }
        
        secondaryLabel.do {
            $0.text = "위시리스트를 추가해\n상품을 모아보세요!"
            $0.textColor = .gray400
            $0.font = .font(.pretendardMedium, ofSize: 16)
            $0.numberOfLines = 0
        }
        
        linkButton.do {
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
        self.contentView.addSubviews(emptyImageView, titleLabel, secondaryLabel, linkButton)
    }
    
    func setConstraints() {
        emptyImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(159)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }
        
        secondaryLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        linkButton.snp.makeConstraints {
            $0.top.equalTo(secondaryLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(-100)
        }
    }
}
