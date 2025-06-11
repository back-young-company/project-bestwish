//
//  ProfileType.swift
//  BestWish
//
//  Created by 이수현 on 6/10/25.
//

import Foundation

enum ProfileType: Int, CaseIterable {
    case profileA
    case profileB
    case profileC
    case profileD
    case profileE
    case profileF
}

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
