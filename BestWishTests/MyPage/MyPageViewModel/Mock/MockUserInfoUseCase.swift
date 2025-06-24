//
//  MockUserInfoUseCase.swift
//  BestWishTests
//
//  Created by 이수현 on 6/24/25.
//

import Foundation
@testable import BestWish

extension String: @retroactive Error { }

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
