//
//  UserDefaultsUseCase.swift
//  BestWishDomain
//
//  Created by 백래훈 on 8/13/25.
//

import Foundation

/// UserDefaults 관리를 위한 UseCase 선언부
public protocol UserDefaultsUseCase {
    /// Bool 값 불러오기
    func bool(forKey key: String) -> Bool
    /// Bool 값 설정
    func set(_ value: Bool, forKey key: String)
    /// 값 제거
    func remove(forKey key: String)
}

/// UserDefaults 관리를 위한 UseCase 구현체
public final class UserDefaultsUseCaseImpl: UserDefaultsUseCase {
    private let repository: UserDefaultsRepository

    public init(repository: UserDefaultsRepository) {
        self.repository = repository
    }

    /// Bool 값 불러오기
    public func bool(forKey key: String) -> Bool {
        repository.bool(forKey: key)
    }

    /// Bool 값 설정
    public func set(_ value: Bool, forKey key: String) {
        repository.set(value, forKey: key)
    }

    /// 값 제거
    public func remove(forKey key: String) {
        repository.remove(forKey: key)
    }
}
