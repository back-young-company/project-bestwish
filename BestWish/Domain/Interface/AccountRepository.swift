//
//  AccountRepository.swift
//  BestWish
//
//  Created by 이수현 on 6/17/25.
//

import Foundation

protocol AccountRepository {
    func logout() async throws
    func withdraw() async throws
}
