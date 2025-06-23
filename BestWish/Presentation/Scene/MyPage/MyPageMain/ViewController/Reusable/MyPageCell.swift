//
//  MyPageCell.swift
//  BestWish
//
//  Created by 이수현 on 6/9/25.
//

import UIKit

import SnapKit
import Then

/// 마이페이지 컬렉션 뷰 셀
final class MyPageCell: UITableViewCell, ReuseIdentifier {

    // MARK: - Private Property
    private let _titleLabel = UILabel()
    private let _seeMoreButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setView()
    }

    required init(coder: NSCoder) {
        fatalError()
    }

    func configure(type: MyPageCellType) {
        _titleLabel.text = type.title
        _seeMoreButton.isHidden = !type.showsSeeMoreButton
    }
}

// MARK: - View 설정
private extension MyPageCell {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        self.selectionStyle = .none

        _titleLabel.do {
            $0.textColor = .black
            $0.font = .font(.pretendardMedium, ofSize: 16)
        }

        _seeMoreButton.do {
            $0.setImage(.init(systemName: "chevron.right"), for: .normal)
            $0.tintColor = .gray200
        }
    }

    func setHierarchy() {
        self.contentView.addSubviews(_titleLabel, _seeMoreButton)
    }

    func setConstraints() {
        _titleLabel.snp.makeConstraints { 
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview().inset(CGFloat(16).fitWidth)
            $0.trailing.equalTo(_seeMoreButton.snp.leading).offset(-8)
        }

        _seeMoreButton.snp.makeConstraints { 
            $0.centerY.equalToSuperview()
            $0.size.equalTo(16)
            $0.trailing.equalToSuperview().inset(CGFloat(16).fitWidth)
        }
    }
}
