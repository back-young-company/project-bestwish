//
//  PlatformShortcutHeaderView.swift
//  BestWish
//
//  Created by 백래훈 on 6/11/25.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class PlatformShortcutHeaderView: UICollectionReusableView, ReuseIdentifier {
    
    private let bestWishLabel = UILabel()
    private let titleLabel = UILabel()
    
    private let editButton = UIButton()
    
    var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }

    func configure(title: String) {
        titleLabel.text = title
    }
    
    var getEditButton: UIButton { editButton }
}

private extension PlatformShortcutHeaderView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        bestWishLabel.do {
            $0.text = "BESTWISH"
            $0.textColor = .gray900
            $0.font = .font(.antonRegular, ofSize: 20)
            $0.numberOfLines = 1
        }
        
        titleLabel.do {
            $0.textColor = .gray900
            $0.font = .font(.pretendardBold, ofSize: 16)
            $0.numberOfLines = 1
        }
        
        editButton.do {
            $0.setTitle("편집", for: .normal)
            $0.setTitleColor(.gray200, for: .normal)
            $0.titleLabel?.font = .font(.pretendardMedium, ofSize: 12)
        }
    }

    func setHierarchy() {
        self.addSubviews(bestWishLabel, titleLabel, editButton)
    }

    func setConstraints() {
        bestWishLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(9)
            $0.leading.equalToSuperview().offset(8)
            $0.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(bestWishLabel.snp.bottom).offset(26.5)
            $0.leading.equalToSuperview().offset(8)
            $0.height.equalTo(16)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        editButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().offset(-8)
        }
    }
}
