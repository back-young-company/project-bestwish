//
//  ProfileUpdateViewModelTests.swift
//  BestWishTests
//
//  Created by 이수현 on 6/24/25.
//

import Foundation
import XCTest
@testable import BestWish

import RxSwift

/// 프로필 업데이트 뷰 모델 테스트 클래스
final class ProfileUpdateViewModelTests: XCTestCase {
    private var viewModel: ProfileUpdateViewModel!
    private var mockUserInfoUseCase: MockUserInfoUseCase!
    private var disposeBag: DisposeBag!

    override func setUp() {
        mockUserInfoUseCase = MockUserInfoUseCase()
        viewModel = ProfileUpdateViewModel(useCase: mockUserInfoUseCase)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        mockUserInfoUseCase = nil
        viewModel = nil
        disposeBag = nil
    }

    /// 유저 정보 불러오기 성공 테스트
    func test_getUserInfo_success() {
        // Given
        let expectation = XCTestExpectation(description: #function)
        let dummyUser = makeDummyUser()
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
        // ProfileUpdateViewModel의 convertUserInfoModel 메서드에선 아래 3가지 항목만 사용
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

    /// 프로필 이미지 업데이트 테스트
    func test_updateProfileImageCode() {
        // Given
        let expectation = XCTestExpectation(description: #function)
        let newImageCode = 3

        let userInfoModel = makeDummyUserInfoModel()
        viewModel.injectIntialUserInfo(userInfoModel)

        var received: UserInfoModel?
        viewModel.state.userInfo
            .bind { userInfo in
                received = userInfo
                expectation.fulfill()
            }.disposed(by: disposeBag)

        // When
        viewModel.action.onNext(.updateProfileImageCode(newImageCode))
        wait(for: [expectation], timeout: 2.0)

        // Then
        XCTAssertEqual(received?.profileImageCode, newImageCode)
    }

    /// 닉네임 업데이트 테스트
    func test_updateNickname() {
        // Given
        let expectation = XCTestExpectation(description: #function)
        let userInfoModel = makeDummyUserInfoModel()
        viewModel.injectIntialUserInfo(userInfoModel)

        let updateNickname = "update nickname"

        var received: UserInfoModel?
        viewModel.state.userInfo
            .bind { userInfo in
                received = userInfo
                expectation.fulfill()
            }.disposed(by: disposeBag)

        // When
        viewModel.action.onNext(.updateNickname(updateNickname))
        wait(for: [expectation], timeout: 2.0)

        // Then
        XCTAssertEqual(received?.nickname, updateNickname)
    }

    /// 유저 정보 저장 성공 테스트
    func test_saveUserInfo_success() {
        // Given
        let expectation = XCTestExpectation(description: #function)
        let prevUser = makeDummyUser()
        mockUserInfoUseCase.user = prevUser

        let updateImageCode = 3
        let updateNickname = "update Nickname"
        let userInfoModel = makeDummyUserInfoModel(
            profileImageCode: updateImageCode,
            nickname: updateNickname
        )
        viewModel.injectIntialUserInfo(userInfoModel)

        var received: Void?
        viewModel.state.completedSave
            .bind { _ in
                received = ()
                expectation.fulfill()
            }.disposed(by: disposeBag)

        // When
        viewModel.action.onNext(.saveUserInfo)
        wait(for: [expectation], timeout: 2.0)

        // Then
        XCTAssertNotNil(received)
        XCTAssertEqual(mockUserInfoUseCase.user?.nickname, updateNickname)
        XCTAssertEqual(mockUserInfoUseCase.user?.profileImageCode, updateImageCode)
    }

    /// 유저 정보 저장 실패 테스트
    func test_saveUserInfo_failure() {
        // Given
        let expectation = XCTestExpectation(description: #function)
        let userInfoModel = makeDummyUserInfoModel()
        viewModel.injectIntialUserInfo(userInfoModel)
        mockUserInfoUseCase.shouldThrow = true

        var received: AppError?
        viewModel.state.error
            .bind { error in
                received = error
                expectation.fulfill()
            }.disposed(by: disposeBag)

        // When
        viewModel.action.onNext(.saveUserInfo)
        wait(for: [expectation], timeout: 2.0)

        // Then
        XCTAssertNotNil(received)
    }

    /// 더미 유저 생성
    private func makeDummyUser() -> UserEntity {
        UserEntity(
            name: nil,
            email: "test@test.com",
            nickname: "Test Nickname",
            gender: nil,
            birth: nil,
            profileImageCode: Int.min,
            authProvider: nil
        )
    }

    /// 더미 유저 정보 모델 생성
    private func makeDummyUserInfoModel(
        profileImageCode: Int = Int.min,
        nickname: String = "test"
    ) -> UserInfoModel {
        UserInfoModel(
            profileImageCode: profileImageCode,
            nickname: nickname
        )
    }
}
