//
//  HomeFlowDelegate.swift
//  BestWishPresentation
//
//  Created by 이수현 on 7/2/25.
//

import Foundation

/// 홈 화면 이동 플로우
public protocol HomeFlowDelegate: AnyObject {
    /// 플랫폼 편집 버튼 탭
    func didTapPlatformEditButton(_ delegate: HomeViewControllerUpdate)

    /// 링크 저장 버튼 탭
    func didTapLinkButton(_ delegate: HomeViewControllerUpdate)

    /// 위시 리스트 편집 버튼 탭
    func didTapWishListEditButton(_ delegate: HomeViewControllerUpdate)

    /// 온보딩 설정
    func setOnboarding()
}
