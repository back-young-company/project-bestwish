//
//  AttributesCell.swift
//  BestWish
//
//  Created by Quarang on 6/13/25.
//

import UIKit

internal import RxSwift
internal import SnapKit
internal import Then

/// 카테고리에 따른 속성 셀
final class AttributeCell: UICollectionViewCell, ReuseIdentifier {
    
    // MARK: - Private Property
    private let _attributeLabel = PaddingLabel(top: 4, left: 12, bottom: 4, right: 12)
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
        _attributeLabel.text = nil
        _disposeBag = DisposeBag()
    }
    
    func configure(attribute: String, isSelected: Bool) {
        _attributeLabel.text = attribute
        // 키워드가 비어 있을 시에는 옵션을 설정하지 않음
        guard attribute != EmptyCategoryCase.emptyKeyword.rawValue else {
            _attributeLabel.backgroundColor = .clear
            _attributeLabel.textColor = .black
            return
        }
        
        let titleFont = UIFont.font(.pretendardBold, ofSize: 14)
        _attributeLabel.font = titleFont
        _attributeLabel.backgroundColor = isSelected ? .primary300 : .gray0
        _attributeLabel.textColor = isSelected ? .gray0 : .gray900
        
        // 라벨이 레이아웃된 뒤 즉시 코너 반경을 갱신해 첫 렌더링에서도 캡슐 모양 유지
        _attributeLabel.layoutIfNeeded()
        _attributeLabel.layer.cornerRadius = _attributeLabel.bounds.height / 2
        _attributeLabel.layer.masksToBounds = true
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
