//
//  MockUserInfoRepository.swift
//  BestWishTests
//
//  Created by 이수현 on 6/25/25.
//

@testable import BestWishDomain
import Foundation

/// Mock UserInfoRepository
final class MockUserInfoRepository: UserInfoRepository {
    func getUserInfo() async throws -> UserEntity {
        UserEntity(
            name: nil,
            email: "",
            nickname: nil,
            gender: nil,
            birth: nil,
            profileImageCode: 0,
            authProvider: nil
        )
    }
    
    func updateUserInfo(profileImageCode: Int?, nickname: String?, gender: Int?, birth: Date?) async throws {
        return
    }
}
