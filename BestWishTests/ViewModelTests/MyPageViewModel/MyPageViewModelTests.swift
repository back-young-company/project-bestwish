//
//  MyPageViewModelTests.swift
//  BestWishTests
//
//  Created by 이수현 on 6/24/25.
//

import Foundation
import XCTest
@testable import BestWish

internal import RxSwift

/// 마이페이지 메인 뷰 모델 테스트 클래스
final class MyPageViewModelTests: XCTestCase {
    private var viewModel: MyPageViewModel!
    private var mockUserInfoUseCase: MockUserInfoUseCase!
    private var mockAccountUseCase: MockAccountUseCase!
    private var disposeBag: DisposeBag!

    override func setUp() {
        mockAccountUseCase = MockAccountUseCase()
        mockUserInfoUseCase = MockUserInfoUseCase()
        viewModel = MyPageViewModel(
            userInfoUseCase: mockUserInfoUseCase,
            accountUseCase: mockAccountUseCase
        )

        disposeBag = DisposeBag()
    }

    override func tearDown() {
        mockAccountUseCase = nil
        mockUserInfoUseCase = nil
        viewModel = nil
        disposeBag = nil
    }

    /// 유저 정보 불러오기 성공 테스트
    func test_getUserInfo_success() {
        // Given
        let expectation = XCTestExpectation(description: #function)
        let dummyUser = UserEntity(
            name: nil,
            email: "test@test.com",
            nickname: "Test Nickname",
            gender: nil,
            birth: nil,
            profileImageCode: 0,
            authProvider: nil
        )
        mockUserInfoUseCase.user = dummyUser

        var received: UserInfoModel?

        viewModel.state.userInfo
            .bind { userInfo in
                received = userInfo
                expectation.fulfill()
            }.disposed(by: disposeBag)

        // When
        viewModel.action.onNext(.getUserInfo)
        wait(for: [expectation], timeout: 2.0)

        // Then
        // MyPageViewModel의 convertUserInfoModel 메서드에선 아래 3가지 항목만 사용
        XCTAssertEqual(dummyUser.email, received?.email)
        XCTAssertEqual(dummyUser.nickname, received?.nickname)
        XCTAssertEqual(dummyUser.profileImageCode, received?.profileImageCode)
    }

    /// 유저 정보 불러오기 실패 테스트
    func test_getUserInfo_failure() {
        // Given
        let expectation = XCTestExpectation(description: #function)
        mockUserInfoUseCase.shouldThrow = true

        var received: AppError?
        viewModel.state.error
            .bind { error in
                received = error
                expectation.fulfill()
            }.disposed(by: disposeBag)

        // When
        viewModel.action.onNext(.getUserInfo)
        wait(for: [expectation], timeout: 2.0)

        // Then
        XCTAssertNotNil(received)
    }

    /// 섹션 정보 불러오기 테스트
    func test_getSection() {
        // Given
        let expectation = XCTestExpectation(description: #function)

        var received: [MyPageSection]?

        viewModel.state.sections
            .bind { sections in
                received = sections
                expectation.fulfill()
            }.disposed(by: disposeBag)

        // When
        viewModel.action.onNext(.getSection)
        wait(for: [expectation], timeout: 2.0)

        // Then
        XCTAssertNotNil(received)
        XCTAssertEqual(received?.count, MyPageSectionType.allCases.count)
        XCTAssertEqual(received?.flatMap { $0.items }.count, MyPageCellType.allCases.count)
    }

    /// 로그아웃 실패 테스트
    func test_logout_failure() {
        // Given
        let expectation = XCTestExpectation(description: #function)
        mockAccountUseCase.shouldThrow = true

        var received: AppError?
        viewModel.state.error
            .bind { error in
                received = error
                expectation.fulfill()
            }.disposed(by: disposeBag)

        // When
        viewModel.action.onNext(.logout)
        wait(for: [expectation], timeout: 2.0)
        
        // Then
        XCTAssertNotNil(received)
    }
}
