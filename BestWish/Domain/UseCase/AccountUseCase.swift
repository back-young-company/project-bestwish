//
//  AccountUseCase.swift
//  BestWish
//
//  Created by 이수현 on 6/17/25.
//

import Foundation

protocol AccountUseCase {
    func logout() async throws
    func withdraw() async throws
}

final class AccountUseCaseImpl: AccountUseCase {
    private let repository: AccountRepository

    init(repository: AccountRepository) {
        self.repository = repository
    }

    func logout() async throws {
        try await repository.logout()
    }

    func withdraw() async throws {
        try await repository.withdraw()
    }
}
