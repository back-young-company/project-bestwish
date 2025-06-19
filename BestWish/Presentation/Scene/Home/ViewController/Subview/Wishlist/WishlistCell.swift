//
//  WishlistCell.swift
//  BestWish
//
//  Created by 백래훈 on 6/10/25.
//

import UIKit

import RxSwift
import Kingfisher
import SnapKit
import Then

final class WishlistCell: UICollectionViewCell, ReuseIdentifier {
    
    private let productImageView = UIImageView()
    
    private let editButton = UIButton()
    
    private let productSaleRateLabel = UILabel()
    private let productPriceLabel = UILabel()
    
    private let hStackView = UIStackView()
    
    private let productNameLabel = UILabel()
    private let brandNameLabel = UILabel()
    
    private let vStackView = UIStackView()
    
    var getEditButton: UIButton { editButton }
    
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

    func configure(type: WishlistProduct, isHidden: Bool, isLastRow: Bool? = nil) {
        productImageView.kf.setImage(with: URL(string: type.productImageURL)!)
        productSaleRateLabel.text = type.productSaleRate
        productPriceLabel.text = type.productPrice
        productNameLabel.text = type.productName
        brandNameLabel.text = type.brandName
        editButton.isHidden = isHidden
        
        vStackView.snp.remakeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(isLastRow ?? false ? -80 : 0)
        }
    }
}

private extension WishlistCell {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        productImageView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
        }
        
        editButton.do {
            var config = UIButton.Configuration.plain()
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
            
            config.image = UIImage(named: "edit")?.withConfiguration(symbolConfig)
            config.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            $0.configuration = config
        }
        
        productSaleRateLabel.do {
            $0.textColor = .secondary400
            $0.font = .font(.pretendardBold, ofSize: 16)
        }
        
        productPriceLabel.do {
            $0.textColor = .black
            $0.font = .font(.pretendardBold, ofSize: 18)
        }
        
        hStackView.do {
            $0.axis = .horizontal
            $0.spacing = 4
            $0.alignment = .center
        }
        
        productNameLabel.do {
            $0.textColor = .black
            $0.font = .font(.pretendardMedium, ofSize: 12)
        }
        
        brandNameLabel.do {
            $0.textColor = .black
            $0.font = .font(.pretendardBold, ofSize: 12)
        }
        
        vStackView.do {
            $0.axis = .vertical
            $0.spacing = 4
            $0.alignment = .leading
        }
    }

    func setHierarchy() {
        hStackView.addArrangedSubviews(productSaleRateLabel, productPriceLabel)
        vStackView.addArrangedSubviews(hStackView, productNameLabel, brandNameLabel)
        self.contentView.addSubviews(productImageView, editButton, vStackView)
    }

    func setConstraints() {
        productImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(productImageView.snp.width)
        }
        
        editButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        vStackView.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
