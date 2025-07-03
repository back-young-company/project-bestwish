//
//  UserInfoRepositoryTests.swift
//  BestWishTests
//
//  Created by 이수현 on 6/25/25.
//

@testable import BestWishData
@testable import BestWishDomain
import Foundation
import XCTest

/// UserInfoRepository 테스트 클래스
final class UserInfoRepositoryTests: XCTestCase {
    private var supabaseUserInfoManager: MockSupabaseUserInfoManager!
    private var repository: UserInfoRepository!

    override func setUp() {
        supabaseUserInfoManager = MockSupabaseUserInfoManager()
        repository = UserInfoRepositoryImpl(manager: supabaseUserInfoManager)
    }

    override func tearDown() {
        supabaseUserInfoManager = nil
        repository = nil
    }

    ///  유저 정보 불러오기 성공 테스트
    func test_getUserInfo_success() async throws {
        // Given
        let userDTO = UserDTO(
            id: UUID(),
            email: "test email",
            name: "test name",
            nickname: "test nickname",
            gender: 0,
            birth: Date(),
            profileImageCode: 0,
            role: "test role",
            platformSequence: [1, 2, 3, 4],
            authProvider: "test authProvider"
        )
        supabaseUserInfoManager.userDTO = userDTO

        // When
        let result = try await supabaseUserInfoManager.getUserInfo()

        // Then
        XCTAssertEqual(userDTO.name, result.name)
        XCTAssertEqual(userDTO.email, result.email)
        XCTAssertEqual(userDTO.nickname, result.nickname)
        XCTAssertEqual(userDTO.gender, result.gender)
        XCTAssertEqual(userDTO.birth, result.birth)
    }

    ///  유저 정보 불러오기 실패 테스트
    func test_getUserInfo_failure() async {
        // Given
        supabaseUserInfoManager.shouldThrow = true

        // When / Then
        do {
            _ = try await repository.getUserInfo()
            XCTFail("Unexpected Success")
        } catch {
            guard let appError = error as? AppError else {
                return XCTFail("Unexpected Error Type: \(error)")
            }

            switch appError {
            case .supabaseError: XCTAssertTrue(true)
            default: XCTFail("Unexpected Error Type")
            }
        }
    }

    /// 유저 정보 업데이트 실패 테스트
    func test_updateUserInfo_failure() async {
        // Given
        supabaseUserInfoManager.shouldThrow = true

        // When / Then
        do {
            _ = try await repository.updateUserInfo(
                profileImageCode: 3,
                nickname: "test",
                gender: 3,
                birth: Date()
            )
            XCTFail("Unexpected Success")
        } catch {
            guard let appError = error as? AppError else {
                return XCTFail("Unexpected Error Type: \(error)")
            }

            switch appError {
            case .supabaseError: XCTAssertTrue(true)
            default: XCTFail("Unexpected Error Type")
            }
        }
    }
}
