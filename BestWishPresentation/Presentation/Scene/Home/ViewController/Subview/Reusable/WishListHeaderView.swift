//
//  WishListHeaderView.swift
//  BestWish
//
//  Created by 백래훈 on 6/27/25.
//

import UIKit

internal import RxSwift
internal import SnapKit
internal import Then

final class WishListHeaderView: UICollectionReusableView, ReuseIdentifier {
    
    // MARK: - Private Property
    private let _productCountLabel = UILabel()
    private let _editButton = UIButton()

    private let _hStackView = UIStackView()

    private let _contentView = UIView()
    private let _emptyImageView = UIImageView()
    private let _titleLabel = UILabel()
    private let _descriptionLabel = UILabel()
    private let _linkButton = UIButton()

    private let _noMatchView = UIView()
    private let _noMatchImage = UIImageView()
    private let _noMatchLabel = UILabel()

    private let _vStackView = UIStackView()

    private var _disposeBag = DisposeBag()

    // MARK: - Internal Property
    var editButton: UIButton { _editButton }
    var linkButton: UIButton { _linkButton }
    var disposeBag: DisposeBag { _disposeBag }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        _disposeBag = DisposeBag()
    }

    func configure(totalCount: Int, filteredCount: Int) {
        if totalCount == 0 {
            // 상품이 아예 없음
            _productCountLabel.isHidden = true
            _editButton.isHidden = true
            _contentView.isHidden = false
            _noMatchView.isHidden = true
        } else if filteredCount == 0 {
            // 상품은 있으나 검색 결과 없음
            _productCountLabel.isHidden = false
            _editButton.isHidden = false
            _productCountLabel.text = "\(totalCount)개"
            _contentView.isHidden = true
            _noMatchView.isHidden = false
        } else {
            // 검색 결과 있음
            _productCountLabel.isHidden = false
            _editButton.isHidden = false
            _productCountLabel.text = "\(filteredCount)개"
            _contentView.isHidden = true
            _noMatchView.isHidden = true
        }
    }
}

// MARK: - WishListFilterHeaderView 설정
private extension WishListHeaderView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        _productCountLabel.do {
            $0.textColor = .gray200
            $0.font = .font(.pretendardMedium, ofSize: 12)
            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }

        _editButton.do {
            $0.setTitle("편집", for: .normal)
            $0.setTitleColor(.gray200, for: .normal)
            $0.titleLabel?.font = .font(.pretendardMedium, ofSize: 12)
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }

        _hStackView.do {
            $0.axis = .horizontal
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 17)
        }

        _contentView.do {
            $0.isHidden = true
        }

        _emptyImageView.do {
            $0.image = UIImage(named: "noProduct")
            $0.contentMode = .scaleAspectFit
        }

        _titleLabel.do {
            $0.text = "위시리스트가 텅 비었어요!"
            $0.textColor = .gray900
            $0.font = .font(.pretendardBold, ofSize: 20)
        }

        _descriptionLabel.do {
            $0.text = "위시리스트를 추가해\n상품을 모아보세요!"
            $0.textColor = .gray600
            $0.textAlignment = .center
            $0.font = .font(.pretendardMedium, ofSize: 16)
            $0.numberOfLines = 0
        }

        _linkButton.do {
            var config = UIButton.Configuration.plain()
            let titleFont = UIFont.font(.pretendardBold, ofSize: 14)

            config.attributedTitle = AttributedString("상품 추가", attributes: AttributeContainer([.font: titleFont]))
            config.baseForegroundColor = .primary200
            config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
            $0.configuration = config
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.primary200?.cgColor
            $0.layer.borderWidth = 1.5
            $0.clipsToBounds = true
        }

        _noMatchView.do {
            $0.isHidden = true
        }

        _noMatchImage.do {
            $0.image = UIImage(systemName: "exclamationmark.circle")
            $0.tintColor = .gray200
        }

        _noMatchLabel.do {
            $0.text = "해당 상품은 존재하지 않습니다.\n다시 검색해 주세요!"
            $0.textColor = .gray600
            $0.textAlignment = .center
            $0.font = .font(.pretendardMedium, ofSize: 16)
            $0.numberOfLines = 0
        }

        _vStackView.do {
            $0.axis = .vertical
        }
    }

    func setHierarchy() {
        _hStackView.addArrangedSubviews(_productCountLabel, _editButton)
        _contentView.addSubviews(_emptyImageView, _titleLabel, _descriptionLabel, _linkButton)
        _noMatchView.addSubviews(_noMatchImage, _noMatchLabel)
        _vStackView.addArrangedSubviews(_hStackView, _contentView, _noMatchView)
        self.addSubviews(_vStackView)
    }

    func setConstraints() {
        _emptyImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.4)
            $0.height.equalTo(_emptyImageView.snp.width)
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

        _noMatchImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.2)
            $0.height.equalTo(_noMatchImage.snp.width)
        }

        _noMatchLabel.snp.makeConstraints {
            $0.top.equalTo(_noMatchImage.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-12)
        }

        _vStackView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().offset(4)
            $0.bottom.equalToSuperview().offset(-3)
        }
    }
}
