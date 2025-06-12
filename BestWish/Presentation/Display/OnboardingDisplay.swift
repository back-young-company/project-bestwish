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
    var nickname: String?
    var gender: Int?
    var birth: Date?
    var birthString: String? {
        guard let birth else { return nil }
        let formatter = DateFormatter()
        // 현재 한국시간으로만 설정
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: birth)
    }
}

extension OnboardingDisplay {
    mutating func updateProfileImageIndex(to index: Int) {
        profileImageIndex = index
    }
    mutating func updateGender(to gender: Int) {
        self.gender = gender
    }
    mutating func updateBirth(to date: Date) {
        self.birth = date
    }
    mutating func updateNickname(to nickname: String) {
        self.nickname = nickname
    }
}
