//
//  MyPageFlowDelegate.swift
//  BestWishPresentation
//
//  Created by 이수현 on 7/2/25.
//

import Foundation

/// 마이페이지 화면 이동 플로우
public protocol MyPageFlowDelegate: AnyObject {
    /// 유저 정보 관리 뷰 탭
    func didTapUserInfoManagementCell()

    /// 서비스 가이드 셀 탭
    func didTapOnboardingCell()

    /// 프로필 업데이트 셀 탭
    func didTapProflieUpateCell()

    /// 로그아웃 셀 탭
    func didTapLogout()

    /// 유저 정보 변경 셀 탭
    func didTapUserInfoUpdateCell()

    /// 회원탈퇴 탭
    func didTapWithdraw()
}
