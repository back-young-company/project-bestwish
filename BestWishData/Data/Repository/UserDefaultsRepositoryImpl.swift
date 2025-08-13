//
//  UserDefaultsRepositoryImpl.swift
//  BestWishData
//
//  Created by 백래훈 on 8/13/25.
//

import BestWishDomain
import Foundation

/// UserDefaults 관리를 위한 repository 구현체
public final class UserDefaultsRepositoryImpl: UserDefaultsRepository {

    private let manager: UserDefaultsManager

    public init(manager: UserDefaultsManager) {
        self.manager = manager
    }

    /// Bool 값 불러오기
    public func bool(forKey key: String) -> Bool {
        manager.bool(forKey: key)
    }

    /// Bool 값 설정
    public func set(_ value: Bool, forKey key: String) {
        manager.set(value, forKey: key)
    }

    /// 값 제거
    public func remove(forKey key: String) {
        manager.remove(forKey: key)
    }
}
