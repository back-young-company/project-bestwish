//
//  AccountDisplay.swift
//  BestWish
//
//  Created by 이수현 on 6/9/25.
//

import Foundation

struct AccountDisplay {
    var profileImageIndex: Int
    var profileImageName: String {
        ProfileType(rawValue: profileImageIndex)?.name ?? ProfileType.profileA.name
    }
    let nickname: String
    let email: String
}

extension AccountDisplay {
    mutating func updateProfileImageIndex(to index: Int) {
        profileImageIndex = index
    }
}
