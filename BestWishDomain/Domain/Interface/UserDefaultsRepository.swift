//
//  UserDefaultsRepository.swift
//  BestWishData
//
//  Created by 백래훈 on 8/13/25.
//

import Foundation

/// UserDefaults 관리를 위한 repository 선언부
public protocol UserDefaultsRepository {
    /// Bool 값 불러오기
    func bool(forKey key: String) -> Bool
    /// Bool 값 설정
    func set(_ value: Bool, forKey key: String)
    /// 값 제거
    func remove(forKey key: String)
}
