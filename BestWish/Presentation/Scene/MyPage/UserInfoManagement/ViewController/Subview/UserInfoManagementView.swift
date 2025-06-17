//
//  UserInfoManagementView.swift
//  BestWish
//
//  Created by 이수현 on 6/11/25.
//

import UIKit

final class UserInfoManagementView: UIView {
    private let stackView = VerticalStackView(spacing: 32)
    private let userInfoManagementStackView = VerticalStackView(spacing: 8)
    private let userInfoManagementTitlelabel = InfoLabel(title: "회원 정보 설정")
    private let userInfoHorizontalStackView = MyPageRowView(
        type: .maximum,
        title: "회원 정보",
        subTitle: "변경 하기"
    )

    private let snsInfoStackView = VerticalStackView(spacing: 8)
    private let snsInfoTitleLabel = InfoLabel(title: "SNS 연결 정보")
    private let snsInfoHorizontalStackView = MyPageRowView(
        type: .subTitle,
        title: "",
        subTitle: "연결완료"
    )

    private let withdrawStackView = MyPageRowView(
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
        snsInfoHorizontalStackView.configure(title: "\(String(describing: authProvider)) 계정")
    }

    func addUnderLine() {
        snsInfoHorizontalStackView.addUnderLine()
    }

    var getUserInfoArrowButton: UIButton { userInfoHorizontalStackView.getArrowButton }
    var getWithdrawButton: UIButton { withdrawStackView.getArrowButton }
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
        self.addSubviews(stackView)
        stackView.addArrangedSubviews(userInfoManagementStackView, snsInfoStackView)
        userInfoManagementStackView.addArrangedSubviews(
            userInfoManagementTitlelabel,
            userInfoHorizontalStackView
        )
        snsInfoStackView.addArrangedSubviews(
            snsInfoTitleLabel,
            snsInfoHorizontalStackView,
            withdrawStackView
        )
    }

    func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(32)
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
        }
    }
}
