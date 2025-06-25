//
//  AccountRepositoryImpl.swift
//  BestWish
//
//  Created by 이수현 on 6/17/25.
//

import Foundation

final class AccountRepositoryImpl: AccountRepository {
    private let manager: SupabaseOAuthManager

    init(manager: SupabaseOAuthManager) {
        self.manager = manager
    }

    func logout() async throws {
        try await manager.signOut()
    }

    func withdraw() async throws {
        try await manager.leaveService()
    }
}
