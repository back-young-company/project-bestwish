//
//  ProfileType.swift
//  BestWish
//
//  Created by 이수현 on 6/10/25.
//

import Foundation

/// 프로필 이미지 타입
enum ProfileType: Int, CaseIterable {
    case profileA
    case profileB
    case profileC
    case profileD
    case profileE
    case profileF
}

// MARK: - 프로필 타입 이미지 name 설정
extension ProfileType {
    var name: String {
        switch self {
        case .profileA: "ProfileA"
        case .profileB: "ProfileB"
        case .profileC: "ProfileC"
        case .profileD: "ProfileD"
        case .profileE: "ProfileE"
        case .profileF: "ProfileF"
        }
    }
}
