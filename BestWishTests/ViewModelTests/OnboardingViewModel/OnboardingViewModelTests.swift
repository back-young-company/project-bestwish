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
        exp.expectedFulfillmentCount = 1
        viewModel.state.showPolicySheet
            .subscribe(onNext: { exp.fulfill() })
            .disposed(by: disposeBag)

        // When
        viewModel.action.onNext(.viewDidAppear)
        viewModel.action.onNext(.viewDidAppear)

        // Then
        wait(for: [exp], timeout: 1.0)
    }

    /// createUserInfo 호출 시 기본 UserInfoModel(profileImageCode: 0) 방출
    func test_createUserInfo_emitsDefaultUserInfo() {
        // Given
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

        // When
        viewModel.action.onNext(.createUserInfo)

        // Then
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(received?.profileImageCode, 0)
    }

    /// 프로필 이미지, 성별, 생년월일 순차 업데이트 시 모두 반영되는지 검증
    func test_profileGenderBirth_updatesCorrectly() {
        // Given
        let exp = expectation(description: #function)
        exp.expectedFulfillmentCount = 4
        var received: UserInfoModel?

        viewModel.state.userInfo
            .skip(1)
            .take(4)
        .subscribe(onNext: { model in
            received = model
            exp.fulfill()
        })
            .disposed(by: disposeBag)

        // When
        viewModel.action.onNext(.createUserInfo)
        viewModel.action.onNext(.selectedProfileIndex(5))
        viewModel.action.onNext(.selectedGender(.female))
        viewModel.action.onNext(.selectedBirth(Date(timeIntervalSince1970: 1000)))

        // Then
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(received?.profileImageCode, 5)
        XCTAssertEqual(received?.gender, Gender.female.rawValue)
        XCTAssertEqual(received?.birth, Date(timeIntervalSince1970: 1000))
    }

    /// 닉네임 입력 반영되는지 검증
    func test_inputNickname() {
        // Given
        let exp = expectation(description: #function)
        let inputNickname = "Hello"
        var received: UserInfoModel?


        // 1) 초기사출(nil), 2) createUserInfo 모델, 3) inputNickname 후 모델 → 세 번째만 받기
        viewModel.state.userInfo
            .skip(2)
            .take(1)
            .subscribe(onNext: { model in
                received = model
                exp.fulfill()
            })
            .disposed(by: disposeBag)

        // When
        viewModel.action.onNext(.createUserInfo)
        viewModel.action.onNext(.inputNickname(inputNickname))

//         Then
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(received?.nickname, inputNickname)

    }

    /// 페이지 이동(next/prev) 경계값 검증
    func test_pageNavigation_bounds() {
        // Given
        let nextExp = expectation(description: "next page")
        let prevExp = expectation(description: "prev page")
        viewModel.state.currentPage
            .skip(1)
            .distinctUntilChanged()
            .subscribe(onNext: { page in
            if page == 1 { nextExp.fulfill() }
            if page == 0 { prevExp.fulfill() }
        })
            .disposed(by: disposeBag)

        // When
        viewModel.action.onNext(.didTapNextPage)
        viewModel.action.onNext(.didTapNextPage)
        viewModel.action.onNext(.didTapPrevPage)

        // Then
        wait(for: [nextExp, prevExp], timeout: 1.0)
    }

    /// uploadUserInfo 호출 성공 시 readyToUseService 방출
    func test_uploadUserInfo_success() {
        // Given
        let exp = expectation(description: #function)
        viewModel.state.readyToUseService
            .subscribe(onNext: { exp.fulfill() })
            .disposed(by: disposeBag)
        viewModel.state.userInfo
            .skip(1)
            .take(1)
            .subscribe(onNext: { model in
            self.viewModel.action.onNext(.uploadUserInfo(model ?? UserInfoModel(profileImageCode: 0)))
        })
            .disposed(by: disposeBag)

        // When
        viewModel.action.onNext(.createUserInfo)

        // Then
        wait(for: [exp], timeout: 1.0)
    }

    /// uploadUserInfo 호출 실패 시 error 방출
    func test_uploadUserInfo_failure() {
        // Given
        mockUseCase.shouldThrow = true
        let exp = expectation(description: #function)
        viewModel.state.error
            .subscribe(onNext: { _ in exp.fulfill() })
            .disposed(by: disposeBag)
        viewModel.state.userInfo
            .skip(1)
            .take(1)
            .subscribe(onNext: { model in
            self.viewModel.action.onNext(.uploadUserInfo(model ?? UserInfoModel(profileImageCode: 0)))
        })
            .disposed(by: disposeBag)

        // When
        viewModel.action.onNext(.createUserInfo)

        // Then
        wait(for: [exp], timeout: 1.0)
    }
}
