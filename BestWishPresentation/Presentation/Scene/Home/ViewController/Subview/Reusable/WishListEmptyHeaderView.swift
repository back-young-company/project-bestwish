//
//  WishListEmptyHeaderView.swift
//  BestWish
//
//  Created by 백래훈 on 6/13/25.
//

import UIKit

internal import RxSwift
internal import RxCocoa
internal import SnapKit
internal import Then

/// 빈 위시리스트 Header View
final class WishListEmptyHeaderView: UICollectionReusableView, ReuseIdentifier {

    // MARK: - Private Property
    private let separatorView = UIView()
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - WishListEmptyHeaderView 설정
private extension WishListEmptyHeaderView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }
    
    func setAttributes() {
        separatorView.do {
            $0.backgroundColor = .gray50
        }
        
        titleLabel.do {
            $0.text = "쇼핑몰 위시리스트"
            $0.textColor = .gray900
            $0.font = .font(.pretendardBold, ofSize: 16)
            $0.numberOfLines = 1
        }
    }

    func setHierarchy() {
        self.addSubviews(separatorView, titleLabel)
    }

    func setConstraints() {
        separatorView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(8)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
}
