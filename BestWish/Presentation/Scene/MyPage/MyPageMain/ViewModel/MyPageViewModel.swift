//
//  MyPageViewModel.swift
//  BestWish
//
//  Created by 이수현 on 6/9/25.
//

import RxRelay
import RxSwift

/// 마이페이지 View Model
final class MyPageViewModel: ViewModel {
    // MARK: - Action
    enum Action {
        case getSection
        case getUserInfo
        case logout
    }

    // MARK: - State
    struct State {
        let sections: Observable<[MyPageSection]>
        let userInfo: Observable<UserInfoModel>
        let isLogOut: Observable<Void>
        let error: Observable<AppError>
    }

    // MARK: - Internal Property
    var action: AnyObserver<Action> { _action.asObserver() }
    let state: State

    // MARK: - Private Property
    private let _action = PublishSubject<Action>()

    private let _sections = PublishSubject<[MyPageSection]>()
    private let _userInfo = PublishSubject<UserInfoModel>()
    private let _isLogOut = PublishRelay<Void>()
    private let _error = PublishSubject<AppError>()

    private let userInfoUseCase: UserInfoUseCase
    private let accountUseCase: AccountUseCase
    private let disposeBag = DisposeBag()

    init(
        userInfoUseCase: UserInfoUseCase,
        accountUseCase: AccountUseCase
    ) {
        self.userInfoUseCase = userInfoUseCase
        self.accountUseCase = accountUseCase
        state = State(
            sections: _sections.asObservable(),
            userInfo: _userInfo.asObservable(),
            isLogOut: _isLogOut.asObservable(),
            error: _error.asObservable()
        )

        bindAction()
    }

    private func bindAction() {
        _action.bind(with: self) { owner, action in
            switch action {
            case .getSection:
                owner.getSection()
            case .getUserInfo:
                owner.getUserInfo()
            case .logout:
                owner.logout()
            }
        }.disposed(by: disposeBag)
    }

    /// 섹션 정보 가져오기
    private func getSection() {
        let sections = MyPageSectionType.allCases.map { type in
            switch type {
            case .userInfo:
                MyPageSection(header: type.title, items: type.cell.map {
                    MyPageCellItem.seeMore(type: $0)
                })
            case .help, .setting:
                MyPageSection(header: type.title, items: type.cell.map {
                    MyPageCellItem.basic(type: $0)
                })
            }
        }
        _sections.onNext(sections)
        _sections.onCompleted()
    }

    /// 유저 정보 가져오기
    private func getUserInfo() {
        Task {
            do {
                let user = try await userInfoUseCase.getUserInfo()
                let UserInfoModel = convertUserInfoModel(from: user)
                _userInfo.onNext(UserInfoModel)
            } catch {
                handleError(error)
            }
        }
    }

    /// 로그아웃
    private func logout() {
        Task {
            do {
                try await accountUseCase.logout()
                _isLogOut.accept(())
            } catch {
                handleError(error)
            }
        }
    }

    /// User Entity -> UserInfoModel 변환 메서드
    private func convertUserInfoModel(from user: UserEntity) -> UserInfoModel {
        UserInfoModel(
            profileImageCode: user.profileImageCode,
            email: user.email,
            nickname: user.nickname
        )
    }

    /// 에러 핸들링
    private func handleError(_ error: Error) {
        if let error = error as? AppError {
            _error.onNext(error)
        } else {
            _error.onNext(AppError.unknown(error))
        }
    }
}
