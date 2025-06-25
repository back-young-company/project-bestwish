//
//  MockSupabaseUserInfoManager.swift
//  BestWishTests
//
//  Created by 이수현 on 6/25/25.
//

import Foundation
@testable import BestWish

/// MockSupabaseUserInfoManager 클래스
final class MockSupabaseUserInfoManager: SupabaseUserInfoManager {
    var shouldThrow = false
    var userDTO: UserDTO?

    func getUserInfo() async throws -> UserDTO {
        if shouldThrow {
            throw SupabaseError.deleteError("getUserInfo - error")
        }

        return userDTO!
    }
    
    func updateUserInfo(
        profileImageCode: Int?,
        nickname: String?,
        gender: Int?,
        birth: Date?
    ) async throws {
        if shouldThrow {
            throw SupabaseError.deleteError("updateUserInfo - error")
        }

        return
    }
}
