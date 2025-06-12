//
//  AppAlert.swift
//  BestWish
//
//  Created by 이수현 on 6/11/25.
//

import Foundation

extension AlertView {
    enum AlertType {
        case withdraw, logout
    }
}

extension AlertView.AlertType {
    var title: String {
        switch self {
        case .withdraw: "회원 탈퇴"
        case .logout: "로그아웃"
        }
    }

    var subTitle: String {
        switch self {
        case .withdraw: 
            """
            회원 탈퇴 시 계정 및 이용 기록은 모두 삭제되며,
            삭제된 데이터는 복구가 불가능합니다.
            탈퇴를 진행할까요?
            """
        case .logout: ""
        }
    }

    var cancelButtonType: AppButton.ButtonType {
        switch self {
        case .withdraw: .cancelWithdraw
        case .logout: .cancelWithdraw
        }
    }

    var confirmButtonType: AppButton.ButtonType {
        switch self {
        case .withdraw: .withdraw
        case .logout: .withdraw
        }
    }
}
