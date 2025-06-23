//
//  SegmentControlHeaderView.swift
//  BestWish
//
//  Created by Quarang on 6/13/25.
//

import UIKit

import RxSwift
import SnapKit
import Then

// MARK: - 세그먼트 컨트롤 뷰 (0번째 index 섹션 헤더)
final class SegmentControlHeaderView: UICollectionReusableView, ReuseIdentifier {
    
    // MARK: - Private Property
    private let _divider = UIView()
    private var _classSegmentControl = UISegmentedControl(items: ["스타일", "상의", "하의", "아우터", "원피스"])
    private var _disposeBag = DisposeBag()
    
    // MARK: - Internal Property
    var classSegmentControl: UISegmentedControl { _classSegmentControl }
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
}

// MARK: - 세그먼트 컨트롤 헤더 설정
private extension SegmentControlHeaderView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }
    
    func setAttributes() {
        _divider.do {
            $0.backgroundColor = .gray50
        }
        _classSegmentControl.do {
            $0.selectedSegmentIndex = 0
            $0.selectedSegmentTintColor = .primary300
            $0.setTitleTextAttributes([
                .foregroundColor: UIColor.gray,
                .font: UIFont.systemFont(ofSize: 14, weight: .semibold)
            ], for: .normal)
            $0.setTitleTextAttributes([
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 14, weight: .semibold)
            ], for: .selected)
        }
    }
    
    func setHierarchy() {
        addSubviews(_divider, _classSegmentControl)
    }
    
    func setConstraints() {
        _divider.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        _classSegmentControl.snp.makeConstraints {
            $0.top.equalTo(_divider.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
