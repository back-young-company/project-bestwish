//
//  MyPageCell.swift
//  BestWish
//
//  Created by 이수현 on 6/9/25.
//

import UIKit

final class MyPageCell: UITableViewCell, ReuseIdentifier {
    private let titleLabel = UILabel()
    private let seeMoreButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError()
    }

    func configure(type: MyPageCellType) {
        titleLabel.text = type.title
        seeMoreButton.isHidden = !type.showsSeeMoreButton
    }
}

private extension MyPageCell {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        self.selectionStyle = .none

        titleLabel.do {
            $0.textColor = .black
            $0.font = .font(.pretendardMedium, ofSize: 16)
        }

        seeMoreButton.do {
            $0.setImage(.init(systemName: "chevron.right"), for: .normal)
            $0.tintColor = .gray200
        }
    }

    func setHierarchy() {
        self.contentView.addSubviews(titleLabel, seeMoreButton)
    }

    func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview().inset(CGFloat(16).fitWidth)
            make.trailing.equalTo(seeMoreButton.snp.leading).offset(-8)
        }

        seeMoreButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(16)
            make.trailing.equalToSuperview().inset(CGFloat(16).fitWidth)
        }
    }
}
