//
//  UserInfoRepository.swift
//  BestWish
//
//  Created by 이수현 on 6/16/25.
//

import Foundation

/// 유저 정보 관련 레포지토리 프로토콜
protocol UserInfoRepository {

    /// 유저 정보 가져오기
    func getUserInfo() async throws -> UserEntity

    /// 유저 정보 업데이트
    func updateUserInfo(
        profileImageCode: Int?,
        nickname: String?,
        gender: Int?,
        birth: Date?
    ) async throws
}
