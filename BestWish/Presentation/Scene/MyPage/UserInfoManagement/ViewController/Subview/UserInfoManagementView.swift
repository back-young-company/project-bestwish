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
    private let changedButton = UIButton()
    private let userInfoHorizontalStackView = MyPageRowView(
        type: .maximum,
        title: "회원 정보",
        subTitle: "변경 하기"
    )

    private let snsInfoStackView = VerticalStackView(spacing: 8)
    private let snsInfoTitleLabel = InfoLabel(title: "SNS 연결 정보")
    private let snsInfoHorizontalStackView = MyPageRowView(
        type: .subTitle,
        title: "카카오 계정",
        subTitle: "연결완료"
    )

    let withdrawStackView = MyPageRowView(
        type: .logout,
        title: "회원 정보를 삭제하시겠어요?",
        subTitle: "회원탈퇴"
    )
    let confirmChangeButton = AppButton(type: .confirmChange)

    override init(frame: CGRect) {
        super.init(frame: frame)

        setView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(loginInfo: String) {
        snsInfoHorizontalStackView.configure(title: "\(loginInfo) 계정")
    }

    func addUnderLine() {
        snsInfoHorizontalStackView.addUnderLine()
    }
}

private extension UserInfoManagementView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        self.backgroundColor = .white
    }

    func setHierarchy() {
        self.addSubviews(stackView, confirmChangeButton)
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

        confirmChangeButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(12)
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(CGFloat(53).fitHeight)
        }
    }
}
