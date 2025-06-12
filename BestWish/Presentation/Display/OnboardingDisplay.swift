//
//  OnboardingDisplay.swift
//  BestWish
//
//  Created by yimkeul on 6/12/25.
//

import Foundation

struct OnboardingDisplay {
    var profileImageIndex: Int
    var profileImageName: String {
        ProfileType(rawValue: profileImageIndex)?.name ?? ProfileType.profileA.name
    }
    let nickname: String?
}

extension OnboardingDisplay {
    mutating func updateProfileImageIndex(to index: Int) {
        profileImageIndex = index
    }
}
