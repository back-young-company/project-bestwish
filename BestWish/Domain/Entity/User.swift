//
//  User.swift
//  BestWish
//
//  Created by 이수현 on 6/16/25.
//

import Foundation

/// 유저 엔티티
struct UserEntity {
    let name: String?
    let email: String
    let nickname: String?
    let gender: Int?
    let birth: Date?
    let profileImageCode: Int
    let authProvider: String?
}
