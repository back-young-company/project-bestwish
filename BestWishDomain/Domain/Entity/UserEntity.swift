//
//  User.swift
//  BestWish
//
//  Created by 이수현 on 6/16/25.
//

import Foundation

/// 유저 엔티티
public struct UserEntity {
    public let name: String?
    public let email: String
    public let nickname: String?
    public let gender: Int?
    public let birth: Date?
    public let profileImageCode: Int
    public let authProvider: String?

    public init(
        name: String?,
        email: String,
        nickname: String?,
        gender: Int?,
        birth: Date?,
        profileImageCode: Int,
        authProvider: String?
    ) {
        self.name = name
        self.email = email
        self.nickname = nickname
        self.gender = gender
        self.birth = birth
        self.profileImageCode = profileImageCode
        self.authProvider = authProvider
    }
}
