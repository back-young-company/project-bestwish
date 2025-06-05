//
//  DummyRepositoryImpl.swift
//  BestWish
//
//  Created by 이수현 on 6/4/25.
//

import Foundation

final class DummyRepositoryImpl: DummyRepository {
    private let service: DummyService

    init(service: DummyService) {
        self.service = service
    }

    func fetchDummy() async throws -> Dummy {
        let result = try await service.fetchDummy()
        return convertToDummy(from: result)
    }
}

// Mapper를 따로 두어도 됨
extension DummyRepositoryImpl {
    func convertToDummy(from dto: DummyDTO) -> Dummy {
        Dummy(title: dto.title, price: dto.price)
    }
}
