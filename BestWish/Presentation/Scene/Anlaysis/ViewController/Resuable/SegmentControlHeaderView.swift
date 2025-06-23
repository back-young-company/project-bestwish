//
//  SegmentControlHeaderView.swift
//  BestWish
//
//  Created by Quarang on 6/13/25.
//

import UIKit
import SnapKit
import Then
import RxSwift

// MARK: - 세그먼트 컨트롤 뷰 (0번째 index 섹션 헤더)
final class SegmentControlHeaderView: UICollectionReusableView, ReuseIdentifier {
    
    private let divider = UIView()
    private var classSegmentControl = UISegmentedControl(items: ["스타일", "상의", "하의", "아우터", "원피스"])
    var disposeBag = DisposeBag()
    
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
        disposeBag = DisposeBag()
    }
    
    public var getClassSegmentControl: UISegmentedControl { classSegmentControl }
}

private extension SegmentControlHeaderView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }
    
    func setAttributes() {
        divider.do {
            $0.backgroundColor = .gray50
        }
        classSegmentControl.do {
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
        addSubviews(divider, classSegmentControl)
    }
    
    func setConstraints() {
        divider.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        classSegmentControl.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
