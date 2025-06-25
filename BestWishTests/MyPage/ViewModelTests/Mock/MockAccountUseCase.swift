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

    func logout() async throws {
        if shouldThrow {
            throw AppError.supabaseError(
                SupabaseError.deleteError("logout Error")
            )
        }
    }
    
    func withdraw() async throws {
        if shouldThrow {
            throw AppError.supabaseError(
                SupabaseError.deleteError("withdraw Error")
            )
        }
    }
}
