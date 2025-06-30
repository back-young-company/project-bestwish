//
//  AccountRepositoryTests.swift
//  BestWishTests
//
//  Created by 이수현 on 6/26/25.
//

import Foundation
import XCTest
@testable import BestWish

/// AccountRepository 테스트 클래스
final class AccountRepositoryTests: XCTestCase {
    private var keyChainManager: MockKeyChainManager!
    private var oAuthManager: MockSupabaseOAuthManager!
    private var repository: AccountRepository!

    override func setUp() {
        keyChainManager = MockKeyChainManager()
        oAuthManager = MockSupabaseOAuthManager()
        repository = AccountRepositoryImpl(manager: oAuthManager, keyChain: keyChainManager)
    }

    override func tearDown() {
        keyChainManager = nil
        oAuthManager = nil
        repository = nil
    }

    /// 온보딩 상태 확인 실패 테스트
    func test_checkOnboardingState_failure() async {
        // Given
        oAuthManager.shouldThrow = true

        // When / Then
        do {
            _ = try await repository.checkOnboardingState()
            XCTFail("Unexpected Success")
        } catch {
            guard let appError = error as? AppError else {
                return XCTFail("Unexpected Error Type: \(error)")
            }

            switch appError {
            case .authError: XCTAssertTrue(true)
            default: XCTFail("Unexpected Error Type")
            }
        }
    }

    /// 로그인 실패 테스트
    func test_login_failure() async {
        // Given
        oAuthManager.shouldThrow = true

        // When / Then
        do {
            _ = try await repository.login(type: .apple)
            XCTFail("Unexpected Success")
        } catch {
            guard let appError = error as? AppError else {
                return XCTFail("Unexpected Error Type: \(error)")
            }

            switch appError {
            case .authError: XCTAssertTrue(true)
            default: XCTFail("Unexpected Error Type")
            }
        }
    }

    /// 로그아웃 실패 테스트
    func test_logout_failure() async {
        // Given
        oAuthManager.shouldThrow = true

        // When / Then
        do {
            _ = try await repository.logout()
            XCTFail("Unexpected Success")
        } catch {
            guard let appError = error as? AppError else {
                return XCTFail("Unexpected Error Type: \(error)")
            }

            switch appError {
            case .authError: XCTAssertTrue(true)
            default: XCTFail("Unexpected Error Type")
            }
        }
    }

    /// 회원탈퇴 실패 테스트
    func test_withdraw_failure() async {
        // Given
        oAuthManager.shouldThrow = true

        // When / Then
        do {
            _ = try await repository.withdraw()
            XCTFail("Unexpected Success")
        } catch {
            guard let appError = error as? AppError else {
                return XCTFail("Unexpected Error Type: \(error)")
            }

            switch appError {
            case .authError: XCTAssertTrue(true)
            default: XCTFail("Unexpected Error Type")
            }
        }
    }
}
