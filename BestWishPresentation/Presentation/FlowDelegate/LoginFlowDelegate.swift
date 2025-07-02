//
//  LoginFlowDelegate.swift
//  BestWishPresentation
//
//  Created by 이수현 on 7/2/25.
//

import Foundation

/// 로그인 화면 이동 플로우
public protocol LoginFlowDelegate: AnyObject {
    /// oauth & 회원가입 결과에 따른 화면 이동
    func readyToUseService(state: Bool)
}
