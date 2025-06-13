//
//  WishlistEditHeaderView.swift
//  BestWish
//
//  Created by 백래훈 on 6/12/25.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class WishlistEditHeaderView: UICollectionReusableView, ReuseIdentifier {
    
    private let platformCountLabel = UILabel()
    private let completeButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(count: Int) {
        platformCountLabel.text = "\(count)개"
    }
}

private extension WishlistEditHeaderView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }
    
    func setAttributes() {
        platformCountLabel.do {
            $0.textColor = .gray200
            $0.font = .font(.pretendardMedium, ofSize: 12)
        }
        
        completeButton.do {
            let titleFont = UIFont.font(.pretendardBold, ofSize: 12)
            var config = UIButton.Configuration.filled()
            config.cornerStyle = .capsule
            config.baseForegroundColor = .white
            config.baseBackgroundColor = .primary300
            config.attributedTitle = AttributedString("완료", attributes: AttributeContainer([.font: titleFont]))
            $0.configuration = config
        }
    }
    
    func setHierarchy() {
        self.addSubviews(platformCountLabel, completeButton)
    }
    
    func setConstraints() {
        platformCountLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-26)
        }
        
        completeButton.snp.makeConstraints {
            $0.centerY.equalTo(platformCountLabel)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.equalTo(48)
            $0.height.equalTo(26)
        }
    }
}
