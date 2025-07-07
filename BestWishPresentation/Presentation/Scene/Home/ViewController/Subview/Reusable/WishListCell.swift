//
//  WishListCell.swift
//  BestWish
//
//  Created by 백래훈 on 6/10/25.
//

import UIKit

internal import Kingfisher
internal import RxSwift
internal import SnapKit
internal import Then

/// 위시리스트 Cell
final class WishListCell: UICollectionViewCell, ReuseIdentifier {

    // MARK: - Private Property
    private let _shadowContainerView = UIView()
    private let _productImageView = UIImageView()
    private let _editButton = UIButton()
    private let _productSaleRateLabel = UILabel()
    private let _productPriceLabel = UILabel()
    private let _hStackView = HorizontalStackView(spacing: 4)
    private let _productNameLabel = UILabel()
    private let _brandNameLabel = UILabel()
    private let _vStackView = VerticalStackView(spacing: 4)
    private let _platformImageView = UIImageView()
    private let _platformNameLabel = UILabel()
    private let _platformHStack = HorizontalStackView(spacing: 4)
    private var _disposeBag = DisposeBag()

    // MARK: - Internal Property
    var getEditButton: UIButton { _editButton }
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

    func configure(type: WishListProductItem, isHidden: Bool, isLastRow: Bool? = nil) {
        guard let url = URL(string: type.productImageURL ?? "") else { return }

        _productSaleRateLabel.text = type.productSaleRate
        _productPriceLabel.text = type.productPrice
        _productNameLabel.text = type.productName
        _brandNameLabel.text = type.brandName
        _editButton.isHidden = isHidden
        _platformImageView.image = UIImage(named: type.platformImage ?? "")
        _platformNameLabel.text = type.platformName
        
        _productSaleRateLabel.isHidden = type.productSaleRate == "0%"
        _productImageView.kf.setImage(with: url) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let value):
                let imageWithBackground = value.image.withBackground()
                self._productImageView.image = imageWithBackground
                self._shadowContainerView.updateShadowPath()
            case .failure(let error):
                NSLog(#function + "\(error.localizedDescription)")
            }
        }

        _vStackView.snp.remakeConstraints {
            $0.top.equalTo(_productImageView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(isLastRow ?? false ? -80 : 0)
        }
    }
}

// MARK: - WishListCell 설정
private extension WishListCell {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        _shadowContainerView.do {
            $0.layer.cornerRadius = 12
            $0.layer.shadowColor = UIColor.gray900?.cgColor
            $0.layer.shadowOpacity = 0.1
            $0.layer.shadowOffset = CGSize(width: 0, height: 1)
            $0.layer.shadowRadius = 4
        }

        _productImageView.do {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 12
            $0.contentMode = .scaleAspectFill
        }
        
        _editButton.do {
            var config = UIButton.Configuration.plain()
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
            
            config.image = UIImage(named: "edit")?.withConfiguration(symbolConfig)
            config.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            $0.configuration = config
        }
        
        _productSaleRateLabel.do {
            $0.textColor = .secondary400
            $0.font = .font(.pretendardBold, ofSize: 16)
        }
        
        _productPriceLabel.do {
            $0.textColor = .black
            $0.font = .font(.pretendardBold, ofSize: 18)
        }
        
        _hStackView.do {
            $0.alignment = .center
        }
        
        _productNameLabel.do {
            $0.textColor = .black
            $0.font = .font(.pretendardMedium, ofSize: 12)
        }
        
        _brandNameLabel.do {
            $0.textColor = .black
            $0.font = .font(.pretendardBold, ofSize: 12)
        }
        
        _vStackView.do {
            $0.alignment = .leading
        }
        
        _platformNameLabel.do {
            $0.textColor = .gray500
            $0.font = .font(.pretendardBold, ofSize: 10)
        }
    }

    func setHierarchy() {
        self.contentView.addSubviews(_shadowContainerView, _editButton, _vStackView)
        _shadowContainerView.addSubview(_productImageView)
        _platformHStack.addArrangedSubviews(_platformImageView, _platformNameLabel)
        _hStackView.addArrangedSubviews(_productSaleRateLabel, _productPriceLabel)
        _vStackView.addArrangedSubviews(_platformHStack, _hStackView, _productNameLabel, _brandNameLabel)
    }

    func setConstraints() {
        _shadowContainerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(_shadowContainerView.snp.width)
          }

        _productImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        _platformImageView.snp.makeConstraints {
            $0.size.equalTo(16)
        }

        _editButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        _vStackView.snp.makeConstraints {
            $0.top.equalTo(_productImageView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
