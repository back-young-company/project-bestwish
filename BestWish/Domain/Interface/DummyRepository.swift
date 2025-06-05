//
//  DummyRepository.swift
//  BestWish
//
//  Created by 이수현 on 6/4/25.
//

import Foundation

protocol DummyRepository {
    func fetchDummy() async throws -> Dummy
}
