//
//  MyPageHeaderView.swift
//  BestWish
//
//  Created by 이수현 on 6/9/25.
//

import UIKit

final class MyPageHeaderView: UITableViewHeaderFooterView, ReuseIdentifier {

    private let profileImageView = UIImageView()
    private let infoStackView = UIStackView()
    private let nicknameLabel = UILabel()
    private let emailLabel = UILabel()
    let seeMoreButton = UIButton()
    private let separatorView = UIView()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(user: AccountDisplay) {
        profileImageView.image = .init(named: user.profileImageName)
        nicknameLabel.text = user.nickname
        emailLabel.text = user.email
    }
}

private extension MyPageHeaderView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        profileImageView.do {
            $0.contentMode = .scaleAspectFit
        }

        infoStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
        }

        nicknameLabel.do {
            $0.textColor = .gray900
            $0.font = .font(.pretendardBold, ofSize: 18)
            $0.numberOfLines = 1
        }

        emailLabel.do {
            $0.textColor = .gray200
            $0.font = .font(.pretendardMedium, ofSize: 14)
            $0.numberOfLines = 1
        }

        seeMoreButton.do {
            $0.setImage(.init(systemName: "chevron.right"), for: .normal)
            $0.tintColor = .gray900
        }

        separatorView.do {
            $0.backgroundColor = .gray50
        }
    }

    func setHierarchy() {
        infoStackView.addArrangedSubviews(nicknameLabel, emailLabel)
        self.addSubviews(profileImageView, infoStackView, seeMoreButton, separatorView)
    }

    func setConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(24)
            make.leading.equalToSuperview().inset(CGFloat(16).fitWidth)
            make.width.equalTo(profileImageView.snp.height)
        }

        infoStackView.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(18)
            make.verticalEdges.equalTo(profileImageView)
        }

        seeMoreButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
            make.trailing.equalToSuperview().inset(CGFloat(16).fitWidth)
        }

        separatorView.snp.makeConstraints { make in
            make.bottom.directionalHorizontalEdges.equalToSuperview()
            make.height.equalTo(8)
        }
    }
}
