//
//  UserInfoModel.swift
//  BestWish
//
//  Created by yimkeul on 6/12/25.
//

import Foundation

/// 유저 정보 Presentation Model
struct UserInfoModel: Equatable {
    var profileImageCode: Int
    var profileImageName: String {
        ProfileType(rawValue: profileImageCode)?.name ?? ProfileType.profileA.name
    }
    var email: String?
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

// MARK: - 프로퍼티 수정 메서드
extension UserInfoModel {
    mutating func updateprofileImageCode(to index: Int) {
        profileImageCode = index
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
