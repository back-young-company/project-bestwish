//
//  DummyUseCaseImpl.swift
//  BestWish
//
//  Created by 이수현 on 6/4/25.
//

import Foundation

final class DummyUseCaseImpl: DummyUseCase {
    private let repository: DummyRepository

    init(repository: DummyRepository) {
        self.repository = repository
    }

    func fetchDummy() async throws -> Dummy {
        try await repository.fetchDummy()
    }
}
