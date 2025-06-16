//
//  KeywordCell.swift
//  BestWish
//
//  Created by Quarang on 6/13/25.
//

import UIKit
import SnapKit
import Then
import RxSwift

// MARK: - 선택한 속성으로 만들어진 키워드 셀
final class KeywordCell: UICollectionViewCell, ReuseIdentifier {
    
    var disposeBag = DisposeBag()
    private let keywordLabel = UILabel()
    private let iconImageView = UIImageView()
    private let horizontalStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        keywordLabel.text = nil
        disposeBag = DisposeBag()
    }
    
    func configure(keyword: String) {
        let titleFont = UIFont.font(.pretendardBold, ofSize: 14)
        keywordLabel.font = titleFont
        keywordLabel.text = keyword
    }
}

private extension KeywordCell {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }
    
    func setAttributes() {
        keywordLabel.do {
            $0.font = UIFont.font(.pretendardBold, ofSize: 14)
            $0.textColor = .gray0
            $0.textAlignment = .center
            $0.lineBreakMode = .byTruncatingTail
        }
        iconImageView.do {
            $0.image = UIImage(systemName: "xmark.circle.fill")
            $0.tintColor = .gray0
            $0.contentMode = .scaleAspectFit
        }
        horizontalStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .center
            $0.backgroundColor = .gray900
            $0.layer.cornerRadius = 15
            $0.layer.masksToBounds = true
            $0.isLayoutMarginsRelativeArrangement = true
            $0.directionalLayoutMargins = .init(top: 4, leading: 10, bottom: 4, trailing: 10)
        }
    }
    
    func setHierarchy() {
        contentView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubviews(keywordLabel, iconImageView)
    }
    
    func setConstraints() {
        horizontalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(20)
        }
    }
}
