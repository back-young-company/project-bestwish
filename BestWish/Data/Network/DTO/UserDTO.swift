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
    let platformSequence: [Int]?
    let authProvider: String?

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
        case authProvider = "auth_provider"
    }

    init(
        id: UUID,
        email: String,
        name: String?,
        nickname: String?,
        gender: Int?,
        birth: Date?,
        profileImageCode: Int?,
        role: String,
        platformSequence: [Int]?,
        authProvider: String?
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.nickname = nickname
        self.gender = gender
        self.birth = birth
        self.profileImageCode = profileImageCode
        self.role = role
        self.platformSequence = platformSequence
        self.authProvider = authProvider
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.email = try container.decode(String.self, forKey: .email)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.nickname = try container.decodeIfPresent(String.self, forKey: .nickname)
        self.gender = try container.decodeIfPresent(Int.self, forKey: .gender)
        if let birth = try container.decodeIfPresent(String.self, forKey: .birth) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.birth = dateFormatter.date(from: birth)
        } else {
            self.birth = nil
        }

        self.profileImageCode = try container.decodeIfPresent(Int.self, forKey: .profileImageCode)
        self.role = try container.decode(String.self, forKey: .role)
        self.platformSequence = try container.decodeIfPresent([Int].self, forKey: .platformSequence)
        self.authProvider = try container.decodeIfPresent(String.self, forKey: .authProvider)
    }
}

struct PlatformSequenceDTO: Codable {
    let platformSequence: [Int16]

    enum CodingKeys: String, CodingKey {
        case platformSequence = "platform_sequence"
    }
}
