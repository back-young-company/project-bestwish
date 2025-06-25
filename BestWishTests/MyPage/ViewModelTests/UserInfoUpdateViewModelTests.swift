//
//  UserInfoUpdateViewModelTests.swift
//  BestWishTests
//
//  Created by 이수현 on 6/24/25.
//

import Foundation
import XCTest
@testable import BestWish

import RxSwift

/// 유저 정보 업데이트 뷰 모델 테스트
final class UserInfoUpdateViewModelTests: XCTestCase {
    private var userInfoUseCase: MockUserInfoUseCase!
    private var viewModel: UserInfoUpdateViewModel!
    private var disposeBag: DisposeBag!

    override func setUp() {
        userInfoUseCase = MockUserInfoUseCase()
        viewModel = UserInfoUpdateViewModel(useCase: userInfoUseCase)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        userInfoUseCase = nil
        viewModel = nil
        disposeBag = nil
    }

    /// 유저 정보 가져오기 성공 테스트
    func test_getUserInfo_success() {
        // Given
        let expectation = XCTestExpectation(description: #function)
        let user = makeDummyUser()
        userInfoUseCase.user = user

        var received: UserInfoModel?
        viewModel.state.userInfo
            .bind { userInfo in
                received = userInfo
                expectation.fulfill()
            }.disposed(by: disposeBag)

        // When
        viewModel.action.onNext(.getUserInfo)
        wait(for: [expectation], timeout: 2)

        // Then
        XCTAssertEqual(received?.birth, user.birth)
        XCTAssertEqual(received?.gender, user.gender)
    }

    /// 유저 정보 가져오기 실패 테스트
    func test_getUserInfo_failure() {
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
        viewModel.action.onNext(.getUserInfo)
        wait(for: [expectation], timeout: 2)

        // Then
        XCTAssertNotNil(received)
    }


    /// 생년월일 업데이트 테스트
    func test_updateBirth() {
        // Given
        let expectation = XCTestExpectation(description: #function)
        let userInfoModel = makeDummyUserInfoModel()
        viewModel.injectIntialUserInfo(userInfoModel)

        var received: UserInfoModel?
        viewModel.state.userInfo
            .bind { userInfo in
                received = userInfo
                expectation.fulfill()
            }.disposed(by: disposeBag)

        // When
        let updateBirth = Date(timeIntervalSince1970: 10000000)
        viewModel.action.onNext(.updateBirth(updateBirth))
        wait(for: [expectation], timeout: 2)

        // Then
        XCTAssertEqual(received?.birth, updateBirth)
    }

    /// 성별 업데이트 테스트
    func test_updateGender() {
        // Given
        let expectation = XCTestExpectation(description: #function)
        let userInfoModel = makeDummyUserInfoModel()
        viewModel.injectIntialUserInfo(userInfoModel)

        var received: UserInfoModel?
        viewModel.state.userInfo
            .bind { userInfo in
                received = userInfo
                expectation.fulfill()
            }.disposed(by: disposeBag)

        // When
        let updateGender = 2
        viewModel.action.onNext(.updateGender(updateGender))
        wait(for: [expectation], timeout: 2)

        // Then
        XCTAssertEqual(received?.gender, updateGender)
    }

    /// 유저 정보 저장 성공 테스트
    func test_saveUserInfo_success() {
        // Given
        let expectation = XCTestExpectation(description: #function)
        let user = makeDummyUser()
        userInfoUseCase.user = user

        var received: Void?
        viewModel.state.completedSave
            .bind { _ in
                received = ()
                expectation.fulfill()
            }.disposed(by: disposeBag)

        // When
        let updateUser = makeDummyUserInfoModel(
            gender: 3,
            birth: Date(timeIntervalSince1970: 100000)
        )
        viewModel.injectIntialUserInfo(updateUser)
        viewModel.action.onNext(.saveUserInfo)
        wait(for: [expectation], timeout: 2)

        // Then
        XCTAssertNotNil(received)
        XCTAssertEqual(userInfoUseCase.user?.gender, updateUser.gender)
        XCTAssertEqual(userInfoUseCase.user?.birth, updateUser.birth)
    }

    /// 유저 정보 저장 실페 테스트
    func test_saveUserInfo_failure() {
        // Given
        let expectation = XCTestExpectation(description: #function)
        let userInfoModel = makeDummyUserInfoModel()
        viewModel.injectIntialUserInfo(userInfoModel)
        userInfoUseCase.shouldThrow = true


        var received: AppError?
        viewModel.state.error
            .bind { error in
                received = error
                expectation.fulfill()
            }.disposed(by: disposeBag)

        // When
        viewModel.action.onNext(.saveUserInfo)
        wait(for: [expectation], timeout: 2)

        // Then
        XCTAssertNotNil(received)
    }

    /// 더미 User 생성
    private func makeDummyUser() -> User {
        User(
            name: nil,
            email: "test",
            nickname: nil,
            gender: Int.min,
            birth: Date(),
            profileImageCode: 0,
            authProvider: nil
        )
    }

    /// 더미 UserInfoModel 생성
    private func makeDummyUserInfoModel(
        gender: Int = Int.min,
        birth: Date = Date()
    ) -> UserInfoModel {
        UserInfoModel(
            profileImageCode: 0,
            gender: gender,
            birth: birth
        )
    }
}
