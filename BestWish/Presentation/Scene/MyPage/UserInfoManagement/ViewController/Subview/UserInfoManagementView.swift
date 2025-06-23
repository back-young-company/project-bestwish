//
//  UserInfoManagementView.swift
//  BestWish
//
//  Created by 이수현 on 6/11/25.
//

import UIKit

import SnapKit
import Then

final class UserInfoManagementView: UIView {
    private let _stackView = VerticalStackView(spacing: 32)
    private let _userInfoManagementStackView = VerticalStackView(spacing: 8)
    private let _userInfoManagementTitlelabel = GroupTitleLabel(title: "회원 정보 설정")
    private let _userInfoHorizontalStackView = MyPageRowView(
        type: .maximum,
        title: "회원 정보",
        subTitle: "변경 하기"
    )

    private let _snsInfoStackView = VerticalStackView(spacing: 8)
    private let _snsInfoTitleLabel = GroupTitleLabel(title: "SNS 연결 정보")
    private let _snsInfoHorizontalStackView = MyPageRowView(
        type: .subTitle,
        title: "",
        subTitle: "연결완료"
    )

    private let _withdrawStackView = MyPageRowView(
        type: .logout,
        title: "회원 정보를 삭제하시겠어요?",
        subTitle: "회원탈퇴"
    )

    override init(frame: CGRect) {
        super.init(frame: frame)

        setView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(authProvider: String?) {
        guard let provider = authProvider else { return }
        _snsInfoHorizontalStackView.configure(title: "\(String(describing: provider)) 계정")
    }

    func addUnderLine() {
        _snsInfoHorizontalStackView.addUnderLine()
    }

    var userInfoArrowButton: UIButton { _userInfoHorizontalStackView.arrowButton }
    var withdrawButton: UIButton { _withdrawStackView.arrowButton }
}

private extension UserInfoManagementView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        self.backgroundColor = .gray0
    }

    func setHierarchy() {
        self.addSubviews(_stackView)
        _stackView.addArrangedSubviews(_userInfoManagementStackView, _snsInfoStackView)
        _userInfoManagementStackView.addArrangedSubviews(
            _userInfoManagementTitlelabel,
            _userInfoHorizontalStackView
        )
        _snsInfoStackView.addArrangedSubviews(
            _snsInfoTitleLabel,
            _snsInfoHorizontalStackView,
            _withdrawStackView
        )
    }

    func setConstraints() {
        _stackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(32)
            $0.directionalHorizontalEdges.equalToSuperview().inset(20)
        }
    }
}
