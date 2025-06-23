//
//  MyPageViewModel.swift
//  BestWish
//
//  Created by 이수현 on 6/9/25.
//

import RxSwift
import RxRelay

final class MyPageViewModel: ViewModel {
    private let userInfoUseCase: UserInfoUseCase
    private let accountUseCase: AccountUseCase

    private let disposeBag = DisposeBag()

    enum Action {
        case getUserInfo
        case logout
    }

    struct State {
        let sections: Observable<[MyPageSection]> = Observable.just(
            MyPageSectionType.allCases.map { type in
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
        )
        let userInfo: Observable<UserInfoModel>
        let error: Observable<AppError>
    }

    private let _action = PublishSubject<Action>()
    var action: AnyObserver<Action> { _action.asObserver() }

    private let _error = PublishSubject<AppError>()
    private let _userInfo = PublishSubject<UserInfoModel>()
    let state: State

    init(userInfoUseCase: UserInfoUseCase, accountUseCase: AccountUseCase) {
        self.userInfoUseCase = userInfoUseCase
        self.accountUseCase = accountUseCase
        state = State(
            userInfo: _userInfo.asObservable(),
            error: _error.asObservable()
        )
        bindAction()
    }

    private func bindAction() {
        _action.bind(with: self) { owner, action in
            switch action {
            case .getUserInfo:
                owner.getUserInfo()
            case .logout:
                owner.logout()
            }
        }.disposed(by: disposeBag)
    }

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

    private func logout() {
        Task {
            do {
                try await accountUseCase.logout()
            } catch {
                handleError(error)
            }
        }
    }

    private func convertUserInfoModel(from user: User) -> UserInfoModel {
        UserInfoModel(
            profileImageCode: user.profileImageCode,
            email: user.email,
            nickname: user.nickname
        )
    }

    private func handleError(_ error: Error) {
        if let error = error as? AppError {
            _error.onNext(error)
        } else {
            _error.onNext(AppError.unknown(error))
        }
    }
}
