//
//  OnboardingViewModelTests.swift
//  BestWishTests
//
//  Created by yimkeul on 6/27/25.
//

import XCTest

import RxSwift
@testable import BestWish

final class OnboardingViewModelTests: XCTestCase {
    private var viewModel: OnboardingViewModel!
    private var mockUseCase: MockUserInfoUseCase!
    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockUseCase = MockUserInfoUseCase()
        viewModel = OnboardingViewModel(useCase: mockUseCase)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        viewModel = nil
        mockUseCase = nil
        disposeBag = nil
        super.tearDown()
    }

    /// viewDidAppear 최초 호출 시 정책 시트 방출, 두 번째부터는 방출되지 않아야 함
    func test_viewDidAppear_showPolicy_once() {
        // Given
        let exp = expectation(description: #function)
        var emissionCount = 0

        viewModel.state.showPolicySheet
            .subscribe(onNext: {
                emissionCount += 1
                exp.fulfill()
            })
            .disposed(by: disposeBag)

        // When
        viewModel.action.onNext(.viewDidAppear) // 1st: emit + complete
        viewModel.action.onNext(.viewDidAppear) // 2nd: no emit (이미 completed)

        // Then
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(emissionCount, 1,
                       "viewDidAppear를 여러 번 호출해도 정책 시트는 한 번만 방출되어야 합니다.")
    }



    /// createUserInfo 호출 시 기본 UserInfoModel(profileImageCode: 0) 방출
    func test_createUserInfo_emitsDefaultUserInfo() {
        let exp = expectation(description: #function)
        var received: UserInfoModel?
        viewModel.state.userInfo
            .skip(1)
            .take(1)
            .subscribe(onNext: {
                received = $0
                exp.fulfill()
            })
            .disposed(by: disposeBag)
        let dummyUserInfo = makeDummyUserInfoModel()
        viewModel.injectIntialUserInfo(dummyUserInfo)

        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(received?.profileImageCode, 0)
    }

    /// selectedProfileIndex 호출 시 profileImageCode 업데이트 검증
    func test_selectedProfileIndex_updatesProfileImageCode() {
        let exp = expectation(description: #function)
        var received: UserInfoModel?
        let dummyUserInfo = makeDummyUserInfoModel()
        viewModel.injectIntialUserInfo(dummyUserInfo)

        viewModel.state.userInfo
            .skip(1)
            .take(1)
            .subscribe(onNext: {
                received = $0
                exp.fulfill()
            })
            .disposed(by: disposeBag)

        viewModel.action.onNext(.selectedProfileIndex(5))

        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(received?.profileImageCode, 5)
    }

    /// selectedGender 호출 시 gender 업데이트 검증
    func test_selectedGender_updatesGender() {
        let exp = expectation(description: #function)
        var received: UserInfoModel?
        let dummyUserInfo = makeDummyUserInfoModel()
        viewModel.injectIntialUserInfo(dummyUserInfo)

        viewModel.state.userInfo
            .skip(1)
            .take(1)
            .subscribe(onNext: {
                received = $0
                exp.fulfill()
            })
            .disposed(by: disposeBag)

        viewModel.action.onNext(.selectedGender(.female))
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(received?.gender, Gender.female.rawValue)
    }

    /// selectedBirth 호출 시 birth 업데이트 검증
    func test_selectedBirth_updatesBirth() {
        let exp = expectation(description: #function)
        var received: UserInfoModel?
        let testDate = Date(timeIntervalSince1970: 1000)
        let dummyUserInfo = makeDummyUserInfoModel()
        viewModel.injectIntialUserInfo(dummyUserInfo)

        viewModel.state.userInfo
            .skip(1)
            .take(1)
            .subscribe(onNext: {
                received = $0
                exp.fulfill()
            })
            .disposed(by: disposeBag)

        viewModel.action.onNext(.selectedBirth(testDate))

        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(received?.birth, testDate)
    }

    /// 닉네임 입력 반영되는지 검증
    func test_inputNickname_updatesNickname() {
        let exp = expectation(description: #function)
        let inputNickname = "Hello"
        var received: UserInfoModel?

        viewModel.state.userInfo
            .skip(2) // 초기(nil), createUserInfo
            .take(1)
            .subscribe(onNext: {
                received = $0
                exp.fulfill()
            })
            .disposed(by: disposeBag)
        let dummyUserInfo = makeDummyUserInfoModel()
        viewModel.injectIntialUserInfo(dummyUserInfo)

        viewModel.action.onNext(.inputNickname(inputNickname))

        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(received?.nickname, inputNickname)
    }

    /// 페이지 이동(next/prev) 경계값 검증
    func test_pageNavigation_bounds() {
        let nextExp = expectation(description: "next page")
        let prevExp = expectation(description: "prev page")
        var pages: [Int] = []
        nextExp.expectedFulfillmentCount = 2 // 기대하는 호출 값 테스트
        prevExp.expectedFulfillmentCount = 1

        viewModel.state.currentPage
            .skip(1)
            .distinctUntilChanged()
            .subscribe(onNext: { page in
                pages.append(page)
                if page == 1 { nextExp.fulfill() }
                if page == 0 { prevExp.fulfill() }
            })
            .disposed(by: disposeBag)

        // 액션 시퀀스: Next → Next(무시) → Prev → Prev(무시) → Prev(무시) → Next
        viewModel.action.onNext(.didTapNextPage) // pages = [1], nextExp #1
        viewModel.action.onNext(.didTapNextPage) // 중복(1→1) 무시
        viewModel.action.onNext(.didTapPrevPage) // pages = [1, 0], prevExp
        viewModel.action.onNext(.didTapPrevPage) // 중복(0→0) 무시
        viewModel.action.onNext(.didTapPrevPage) // 중복 무시
        viewModel.action.onNext(.didTapNextPage) // pages = [1, 0, 1], nextExp #2

        wait(for: [nextExp, prevExp], timeout: 1.0)
        XCTAssertEqual(pages, [1, 0, 1], "next/prev 페이지 이동이 올바르게 처리되어야 합니다.")
    }

    /// uploadUserInfo 호출 성공 시 readyToUseService 방출
    func test_uploadUserInfo_success() {
        let exp = expectation(description: #function)
        var didReady = false
        let dummyUserInfo = makeDummyUserInfoModel()

        viewModel.state.readyToUseService
            .subscribe(onNext: {
                didReady = true
                exp.fulfill()
            })
            .disposed(by: disposeBag)

        viewModel.state.userInfo
            .skip(1)
            .take(1)
            .subscribe(onNext: { model in
                self.viewModel.action.onNext(.uploadUserInfo(model ?? dummyUserInfo))
            })
            .disposed(by: disposeBag)


        viewModel.injectIntialUserInfo(dummyUserInfo)

        wait(for: [exp], timeout: 1.0)
        XCTAssertTrue(didReady, "uploadUserInfo 성공 시 readyToUseService가 방출되어야 합니다.")
    }

    /// uploadUserInfo 호출 실패 시 error 방출
    func test_uploadUserInfo_failure() {
        mockUseCase.shouldThrow = true
        let exp = expectation(description: #function)
        var didError = false
        let dummyUserInfo = makeDummyUserInfoModel()

        viewModel.state.error
            .subscribe(onNext: { _ in
                didError = true
                exp.fulfill()
            })
            .disposed(by: disposeBag)
        viewModel.state.userInfo
            .skip(1)
            .take(1)
            .subscribe(onNext: { model in
                self.viewModel.action.onNext(.uploadUserInfo(model ?? dummyUserInfo))
            })
            .disposed(by: disposeBag)

        viewModel.action.onNext(.createUserInfo)

        wait(for: [exp], timeout: 1.0)
        XCTAssertTrue(didError, "uploadUserInfo 실패 시 error가 방출되어야 합니다.")
    }

    /// 더미 유저 정보 모델 생성
    private func makeDummyUserInfoModel() -> UserInfoModel {
        return UserInfoModel(profileImageCode: 0)
    }
}
