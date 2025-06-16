//
//  MyPageViewModel.swift
//  BestWish
//
//  Created by 이수현 on 6/9/25.
//

import RxSwift
import RxRelay

final class MyPageViewModel: ViewModel {
    private let useCase: UserInfoUseCase
    private let disposeBag = DisposeBag()

    enum Action {
        case viewDidLoad
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
        let userInfo: Observable<AccountDisplay>
    }

    private let _action = PublishSubject<Action>()
    var action: AnyObserver<Action> { _action.asObserver() }

    private let _userInfo = PublishSubject<AccountDisplay>()
    let state: State

    init(useCase: UserInfoUseCase) {
        self.useCase = useCase
        state = State(userInfo: _userInfo.asObservable() )
        bindAction()
    }

    private func bindAction() {
        _action.bind(with: self) { owner, action in
            switch action {
            case .viewDidLoad:
                owner.getUserInfo()
            }
        }.disposed(by: disposeBag)
    }

    private func getUserInfo() {
        Task {
            let user = try await useCase.getUserInfo()
            let accountDisplay = convertAccountDisplay(from: user)
            _userInfo.onNext(accountDisplay)
        }
    }

    private func convertAccountDisplay(from user: User) -> AccountDisplay {
        AccountDisplay(
            profileImageIndex: user.profileImageCode,
            nickname: user.nickname,
            email: user.email
        )
    }
}
