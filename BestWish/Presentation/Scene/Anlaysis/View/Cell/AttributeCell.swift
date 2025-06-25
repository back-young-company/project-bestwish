//
//  AttributesCell.swift
//  BestWish
//
//  Created by Quarang on 6/13/25.
//

import UIKit
import SnapKit
import Then
import RxSwift

// MARK: - 카테고리에 따른 속성 셀
final class AttributeCell: UICollectionViewCell, ReuseIdentifier {
    
    var disposeBag = DisposeBag()
    private let attributeLabel = PaddingLabel(top: 4, left: 12, bottom: 4, right: 12)
    
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
        attributeLabel.text = nil
        disposeBag = DisposeBag()
    }
    
    func configure(attribute: String, isSelected: Bool) {
        attributeLabel.text = attribute
        // 키워드가 비어 있을 시에는 옵션을 설정하지 않음
        guard attribute != emptyKeyword else {
            attributeLabel.backgroundColor = .clear
            return
        }
        
        let titleFont = UIFont.font(.pretendardBold, ofSize: 14)
        attributeLabel.font = titleFont
        attributeLabel.backgroundColor = isSelected ? .primary300 : .gray0
        attributeLabel.textColor = isSelected ? .gray0 : .gray900
    }
}

private extension AttributeCell {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }
    
    func setAttributes() {
        attributeLabel.do {
            $0.font = UIFont.font(.pretendardBold, ofSize: 14)
            $0.textColor = .gray900
            $0.backgroundColor = .gray0
            $0.textAlignment = .center
            $0.layer.cornerRadius = 15
            $0.layer.masksToBounds = true
        }
    }
    
    func setHierarchy() {
        contentView.addSubview(attributeLabel)
    }
    
    func setConstraints() {
        attributeLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
