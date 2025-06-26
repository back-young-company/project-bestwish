//
//  AttributesCell.swift
//  BestWish
//
//  Created by Quarang on 6/13/25.
//

import UIKit

import RxSwift
import SnapKit
import Then

/// 카테고리에 따른 속성 셀
final class AttributeCell: UICollectionViewCell, ReuseIdentifier {
    
    // MARK: - Private Property
    private let _attributeLabel = PaddingLabel(top: 4, left: 12, bottom: 4, right: 12)
    private var _disposeBag = DisposeBag()
    
    // MARK: - Internal Property
    var disposeBag: DisposeBag { _disposeBag }
    
    private let emptyKeyword = "해당 카테고리의 키워드를 인식할 수 없습니다."
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        _attributeLabel.text = nil
        _disposeBag = DisposeBag()
    }
    
    func configure(attribute: String, isSelected: Bool) {
        _attributeLabel.text = attribute
        // 키워드가 비어 있을 시에는 옵션을 설정하지 않음
        guard attribute != emptyKeyword else {
            _attributeLabel.backgroundColor = .clear
            return
        }
        
        let titleFont = UIFont.font(.pretendardBold, ofSize: 14)
        _attributeLabel.font = titleFont
        _attributeLabel.backgroundColor = isSelected ? .primary300 : .gray0
        _attributeLabel.textColor = isSelected ? .gray0 : .gray900
    }
}

// MARK: - 셀 설정
private extension AttributeCell {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }
    
    func setAttributes() {
        _attributeLabel.do {
            $0.font = UIFont.font(.pretendardBold, ofSize: 14)
            $0.textColor = .gray900
            $0.backgroundColor = .gray0
            $0.textAlignment = .center
            $0.layer.cornerRadius = 15
            $0.layer.masksToBounds = true
        }
    }
    
    func setHierarchy() {
        contentView.addSubview(_attributeLabel)
    }
    
    func setConstraints() {
        _attributeLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
