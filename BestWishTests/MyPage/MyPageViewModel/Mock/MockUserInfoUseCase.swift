//
//  MockUserInfoUseCase.swift
//  BestWishTests
//
//  Created by 이수현 on 6/24/25.
//

import Foundation
@testable import BestWish

// MARK: - Error 타입 반환을 손쉽게 하기 위해 사용
extension String: @retroactive Error { }

/// Mock UserInfo Use Case
final class MockUserInfoUseCase: UserInfoUseCase {
    var shouldThrow = false
    var user: User?

    func getUserInfo() async throws -> User {
        if shouldThrow {
            throw AppError.supabaseError(
                SupabaseError.selectError("getUserInfo Error")
            )
        }

        return user!
    }
    
    func isValidNickname(_ nickname: String) -> Bool {
        true
    }
}
