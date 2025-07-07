//
//  MyPageHeaderView.swift
//  BestWish
//
//  Created by 이수현 on 6/9/25.
//

import UIKit

internal import SnapKit
internal import Then

/// 마이페이지 테이블 뷰  헤더 뷰
final class MyPageHeaderView: UITableViewHeaderFooterView, ReuseIdentifier {

    // MARK: - Private Property
    private let _profileImageView = UIImageView()
    private let _infoStackView = UIStackView()
    private let _nicknameLabel = UILabel()
    private let _emailLabel = UILabel()
    private let _seeMoreButton = UIButton()
    private let _separatorView = UIView()

    // MARK: - Internal Property
    var seeMoreButton: UIButton { _seeMoreButton }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(user: UserInfoModel) {
        _profileImageView.image = .init(named: user.profileImageName)
        _nicknameLabel.text = user.nickname
        _emailLabel.text = user.email
    }
}

// MARK: - View 설정
private extension MyPageHeaderView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        _profileImageView.do {
            $0.contentMode = .scaleAspectFit
        }

        _infoStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
        }

        _nicknameLabel.do {
            $0.textColor = .gray900
            $0.font = .font(.pretendardBold, ofSize: 18)
            $0.numberOfLines = 1
        }

        _emailLabel.do {
            $0.textColor = .gray200
            $0.font = .font(.pretendardMedium, ofSize: 14)
            $0.numberOfLines = 1
        }

        _seeMoreButton.do {
            var config = UIButton.Configuration.plain()
            config.contentInsets = .init(top: 12, leading: 12, bottom: 12, trailing: 12)
            config.image = .init(systemName: "chevron.right")
            config.baseForegroundColor = .gray900
            $0.configuration = config
            $0.isUserInteractionEnabled = false
        }

        _separatorView.do {
            $0.backgroundColor = .gray50
        }
    }

    func setHierarchy() {
        _infoStackView.addArrangedSubviews(_nicknameLabel, _emailLabel)
        self.addSubviews(_profileImageView, _infoStackView, _seeMoreButton, _separatorView)
    }

    func setConstraints() {
        _profileImageView.snp.makeConstraints { 
            $0.verticalEdges.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(CGFloat(16).fitWidth)
            $0.width.equalTo(_profileImageView.snp.height)
        }

        _infoStackView.snp.makeConstraints { 
            $0.leading.equalTo(_profileImageView.snp.trailing).offset(18)
            $0.centerY.equalTo(_profileImageView)
        }

        _seeMoreButton.snp.makeConstraints { 
            $0.centerY.equalToSuperview()
            $0.size.equalTo(48)
            $0.trailing.equalToSuperview().inset(8)
        }

        _separatorView.snp.makeConstraints { 
            $0.bottom.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(8)
        }
    }
}
