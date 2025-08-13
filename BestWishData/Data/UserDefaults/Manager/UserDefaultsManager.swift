//
//  UserDefaultsManager.swift
//  BestWishData
//
//  Created by 백래훈 on 8/13/25.
//

import Foundation

internal import FirebaseAnalytics

/// UserDefaults 접근을 위한 UserDefaultsManager 클래스
public final class UserDefaultsManager {

    private let userDefaults: UserDefaults

    public init(suiteName: String?) {
        if let suiteName, let userDefaults = UserDefaults(suiteName: suiteName) {
            self.userDefaults = userDefaults
        } else {
            self.userDefaults = .standard
        }
    }

    func bool(forKey key: String) -> Bool {
        userDefaults.bool(forKey: key)
    }

    func set(_ value: Bool, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }

    func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
