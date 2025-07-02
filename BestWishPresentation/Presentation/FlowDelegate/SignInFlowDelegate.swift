//
//  SignInFlowDelegate.swift
//  BestWishPresentation
//
//  Created by 이수현 on 7/2/25.
//

import Foundation

public protocol SignInFlowDelegate: AnyObject {
    /// 회원가입 결과에 따른 화면 이동
    func readyToUse()

    //TODO: PolicyVC, ProfileSheetVC 등 present로 띄우는 VC 상의 필요
}
