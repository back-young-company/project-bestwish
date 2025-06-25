//
//  MockAccountUseCase.swift
//  BestWishTests
//
//  Created by 이수현 on 6/24/25.
//

import Foundation
@testable import BestWish

final class MockAccountUseCase: AccountUseCase {
    var shouldThrow = false

    func login(type: BestWish.SocialType) async throws -> Bool {
        true
    }

    func logout() async throws -> Bool {
        if shouldThrow {
            throw AppError.supabaseError(
                SupabaseError.deleteError("logout Error")
            )
        }
        return true
    }
    
    func withdraw() async throws -> Bool {
        if shouldThrow {
            throw AppError.supabaseError(
                SupabaseError.deleteError("withdraw Error")
            )
        }
        return true
    }
}
