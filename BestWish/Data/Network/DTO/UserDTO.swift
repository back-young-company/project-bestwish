//
//  UserDTO.swift
//  BestWish
//
//  Created by 이수현 on 6/5/25.
//

import Foundation

struct UserDTO: Codable {
    let id: UUID
    let email: String
    let name: String?
    let nickname: String?
    let gender: Int?
    let birth: Date?
    let profileImageCode: Int?
    let role: String
    let platformSequence: [Int]
    let authProvieder: String

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case nickname
        case gender
        case birth
        case profileImageCode = "profile_image_code"
        case role
        case platformSequence = "platform_sequence"
        case authProvieder = "auth_provider"
    }
}
