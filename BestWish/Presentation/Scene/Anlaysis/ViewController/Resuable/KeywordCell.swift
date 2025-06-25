//
//  KeywordCell.swift
//  BestWish
//
//  Created by Quarang on 6/13/25.
//

import UIKit

import RxSwift
import SnapKit
import Then

/// 선택한 속성으로 만들어진 키워드 셀
final class KeywordCell: UICollectionViewCell, ReuseIdentifier {
    
    // MARK: - Private Property
    private let _keywordLabel = UILabel()
    private let _iconImageView = UIImageView()
    private let _horizontalStackView = HorizontalStackView(spacing: 8)
    private var _disposeBag = DisposeBag()
    
    // MARK: - Internal Property
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
        _keywordLabel.text = nil
        _disposeBag = DisposeBag()
    }
    
    func configure(keyword: String) {
        let titleFont = UIFont.font(.pretendardBold, ofSize: 14)
        _keywordLabel.font = titleFont
        _keywordLabel.text = keyword
    }
}

// MARK: - 키워드 셀 설정
private extension KeywordCell {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }
    
    func setAttributes() {
        _keywordLabel.do {
            $0.font = UIFont.font(.pretendardBold, ofSize: 14)
            $0.textColor = .gray0
            $0.textAlignment = .center
            $0.lineBreakMode = .byTruncatingTail
        }
        _iconImageView.do {
            $0.image = UIImage(systemName: "xmark.circle.fill")
            $0.tintColor = .gray0
            $0.contentMode = .scaleAspectFit
        }
        _horizontalStackView.do {
            $0.alignment = .center
            $0.backgroundColor = .gray900
            $0.layer.cornerRadius = 15
            $0.layer.masksToBounds = true
            $0.isLayoutMarginsRelativeArrangement = true
            $0.directionalLayoutMargins = .init(top: 4, leading: 10, bottom: 4, trailing: 10)
        }
    }
    
    func setHierarchy() {
        contentView.addSubview(_horizontalStackView)
        _horizontalStackView.addArrangedSubviews(_keywordLabel, _iconImageView)
    }
    
    func setConstraints() {
        _horizontalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        _iconImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }
    }
}
