//
//  DummyServiceImpl.swift
//  BestWish
//
//  Created by 이수현 on 6/4/25.
//

import Foundation

final class DummyServiceImpl: DummyService {
    func fetchDummy() async throws -> DummyDTO {
        DummyDTO(title: "Dummy", price: 1000.0)
    }
}
