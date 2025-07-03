//
//  UserInfoUseCaseTests.swift
//  BestWishTests
//
//  Created by 이수현 on 6/25/25.
//

@testable import BestWishData
@testable import BestWishDomain
import Foundation
import XCTest

/// 유저 정보 유스케이스 테스트 클래스
final class UserInfoUseCaseTests: XCTestCase {
    private var userInfoRepository: MockUserInfoRepository!
    private var useCase: UserInfoUseCase!

    override func setUp() {
        userInfoRepository = MockUserInfoRepository()
        useCase = UserInfoUseCaseImpl(repository: userInfoRepository)
    }

    override func tearDown() {
        userInfoRepository = nil
        useCase = nil
    }

    /// 닉네임 유효성 검사 실패 테스트 (공백 포함)
    func test_isValidNickname_whiteSpace_failure() {
        // Given
        let nicknames = [
            "Test  ",
            " Test",
            "T est",
            " Tes t ",
        ]

        // When
        let results = nicknames.map { ($0, useCase.isValidNickname($0)) }

        // Then
        results.forEach { nickname, result in
            XCTAssertFalse(result, "nickname '\(nickname)' should be invalid due to white space")
        }
    }

    /// 닉네임 유효성 검사 실패 테스트  (특수문자 포함)
    func test_isValidNickname_specialCharacters_failure() {
        // Given
        let nicknames = [
            "Test!",
            "!Test",
            "Test.",
            "*Test*",
            "!Te#s$t",
            "Tes^t",
            "!!!!!!",
            "😀Test😀",
            "Test_01"
        ]

        // When
        let results = nicknames.map { ($0, useCase.isValidNickname($0)) }

        // Then
        results.forEach { nickname, result in
            XCTAssertFalse(result, "nickname '\(nickname)' should be invalid due to spacial characters")
        }
    }

    /// 닉네임 유효성 검사 실패 테스트  (문자열 길이)
    func test_isValidNickname_lengh_failure() {
        // Given
        let nicknames = [
            "01234567899",
            "0",
            "A",
            "a",
            "AAAAAAAAAAA",
            "테스트테스트테스트테스트",
            "가",
            "ㄱ",
            "가ㄴ"
        ]

        // When
        let results = nicknames.map { ($0, useCase.isValidNickname($0)) }

        // Then
        results.forEach { nickname, result in
            XCTAssertFalse(result, "nickname '\(nickname)' should be invalid due to length (2-10)")
        }
    }

    /// 닉네임 유효성 검사 성공 테스트
    func test_isValidNickname_success() {
        // Given
        let nicknames = [
            "0123456789", // 숫자 10자
            "ABCDEFGHIJ", // 영문 10자
            "가나다라마바사아자차", // 한글 10자
            "01", // 숫자 2자
            "Aa", // 영문 2자
            "A1", // 혼합 2자
            "0가Aa하2", // 혼합
            "깎껋꿹쒥쀙",
        ]

        // When
        let results = nicknames.map { ($0, useCase.isValidNickname($0)) }

        // Then
        results.forEach { nickname, result in
            XCTAssertTrue(result, "nickname '\(nickname)' should be valid")
        }
    }
}
