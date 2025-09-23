//
//  SupabaseUserInfoManager.swift
//  BestWish
//
//  Created by 이수현 on 6/16/25.
//

import Foundation

public protocol SupabaseUserInfoManager {
    /// 유저 정보 불러오기
    func getUserInfo() async throws -> UserDTO
    
    /// 유저 정보 업데이트
    func updateUserInfo(
        profileImageCode: Int?,
        nickname: String?,
        gender: Int?,
        birth: Date?
    ) async throws
}
