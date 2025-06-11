//
//  PlatformHeaderView.swift
//  BestWish
//
//  Created by 백래훈 on 6/11/25.
//

import UIKit

import SnapKit
import Then

final class PlatformHeaderView: UICollectionReusableView, ReuseIdentifier {
    
    private let bestWishLabel = UILabel()
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(title: String) {
        titleLabel.text = title
    }
}

private extension PlatformHeaderView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        bestWishLabel.do {
            $0.text = "BESTWISH"
            $0.textColor = .gray900
            $0.font = .font(.pretendardExtraBold, ofSize: 20)
        }
        
        titleLabel.do {
            $0.textColor = .gray900
            $0.font = .font(.pretendardBold, ofSize: 16)
        }
    }

    func setHierarchy() {
        self.addSubviews(bestWishLabel, titleLabel)
    }

    func setConstraints() {
        bestWishLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(8)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(bestWishLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
}
