//
//  MWishListHeaderView.swift
//  BestWish
//
//  Created by 백래훈 on 6/27/25.
//

import UIKit

import SnapKit
import Then

final class MWishListHeaderView: UICollectionReusableView, ReuseIdentifier {
    // MARK: - Private Property
    private let _productCountLabel = UILabel()
    private let _editButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(productCount: Int) {
        _productCountLabel.text = "\(productCount)개"
    }
}

// MARK: - FilterHeaderView 설정
private extension MWishListHeaderView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        _productCountLabel.do {
            $0.textColor = .gray200
            $0.font = .font(.pretendardMedium, ofSize: 12)
        }

        _editButton.do {
            $0.setTitle("편집", for: .normal)
            $0.setTitleColor(.gray200, for: .normal)
            $0.titleLabel?.font = .font(.pretendardMedium, ofSize: 12)
        }
    }

    func setHierarchy() {
        self.addSubviews(_productCountLabel, _editButton)
    }

    func setConstraints() {
        _productCountLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().offset(20)
        }

        _editButton.snp.makeConstraints {
            $0.centerY.equalTo(_productCountLabel)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
}
