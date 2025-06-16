//
//  UserInfoUseCase.swift
//  BestWish
//
//  Created by 이수현 on 6/16/25.
//

import Foundation

protocol UserInfoUseCase {
    func getUserInfo() async throws -> User
}

final class UserInfoUseCaseImpl: UserInfoUseCase {
    private let repository: UserInfoRepository

    init(repository: UserInfoRepository) {
        self.repository = repository
    }

    func getUserInfo() async throws -> User {
        try await repository.getUserInfo()
    }
}
