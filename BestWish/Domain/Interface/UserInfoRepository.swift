//
//  UserInfoRepository.swift
//  BestWish
//
//  Created by 이수현 on 6/16/25.
//

import Foundation

protocol UserInfoRepository {
    func getUserInfo() async throws -> User
    func updateUserInfo(
        profileImageCode: Int?,
        nickname: String?,
        gender: Int?,
        birth: Date?
    ) async throws
}
