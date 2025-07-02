//
//  UserInfoManagementViewModelTests.swift
//  BestWishTests
//
//  Created by 이수현 on 6/24/25.
//

@testable import BestWishDomain
@testable import BestWishPresentation
import Foundation
import XCTest

internal import RxSwift

/// 유저 정보 관리 뷰 모델 테스트 클래스
final class UserInfoManagementViewModelTests: XCTestCase {
    private var viewModel: UserInfoManagementViewModel!
    private var userInfoUseCase: MockUserInfoUseCase!
    private var accountUseCase: MockAccountUseCase!
    private var disposeBag: DisposeBag!

    override func setUp() {
        userInfoUseCase = MockUserInfoUseCase()
        accountUseCase = MockAccountUseCase()
        viewModel = UserInfoManagementViewModel(
            userInfoUseCase: userInfoUseCase,
            accountUseCase: accountUseCase
        )
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        userInfoUseCase = nil
        accountUseCase = nil
        viewModel = nil
        disposeBag = nil
    }

    /// 계정 연결 정보 불러오기 성공 테스트
    func test_getAuthProvider_success() {
        // Given
        let expectation = XCTestExpectation(description: #function)
        let authProvider = "kakao"
        let user = UserEntity(
            name: nil,
            email: "test",
            nickname: nil,
            gender: nil,
            birth: nil,
            profileImageCode: 0,
            authProvider: authProvider
        )
        userInfoUseCase.user = user

        var received: String?
        viewModel.state.authProvider
            .bind { result in
                received = result
                expectation.fulfill()
            }.disposed(by: disposeBag)

        // When
        viewModel.action.onNext(.getAuthProvider)
        wait(for: [expectation], timeout: 2)

        // Then
        XCTAssertEqual(received, authProvider)
    }

    /// 계정 연결 정보 불러오기 실패 테스트
    func test_getAuthProvider_failure() {
        // Given
        let expectation = XCTestExpectation(description: #function)
        userInfoUseCase.shouldThrow = true

        var received: AppError?
        viewModel.state.error
            .bind { error in
                received = error
                expectation.fulfill()
            }.disposed(by: disposeBag)

        // When
        viewModel.action.onNext(.getAuthProvider)
        wait(for: [expectation], timeout: 2)

        // Then
        XCTAssertNotNil(received)
    }

    /// 회원 탈퇴 실패 테스트
    func test_withdraw_failure() {
        // Given
        let expectation = XCTestExpectation(description: #function)
        accountUseCase.shouldThrow = true

        var received: AppError?
        viewModel.state.error
            .bind { error in
                received = error
                expectation.fulfill()
            }.disposed(by: disposeBag)

        // When
        viewModel.action.onNext(.withdraw)
        wait(for: [expectation], timeout: 2)

        // Then
        XCTAssertNotNil(received)
    }
}

