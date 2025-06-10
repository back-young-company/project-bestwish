//
//  MyPageViewModel.swift
//  BestWish
//
//  Created by 이수현 on 6/9/25.
//

import RxSwift
import RxRelay

final class MyPageViewModel: ViewModel {
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
                case .help,
                        .setting:
                    MyPageSection(header: type.title, items: type.cell.map {
                        MyPageCellItem.basic(type: $0)
                    })
                }
            }
        )
        let userInfo: Observable<AccountDisplay> = Observable.just(
            AccountDisplay(
                profileImageName: "person.crop.circle",
                nickname: "User",
                email: "user@gmail.com"
            )
        )
    }

    private let _action = PublishSubject<Action>()
    var action: AnyObserver<Action> { _action.asObserver() }

    let state: State

    init() {
        state = State()
        bindAction()
    }

    private func bindAction() {

    }
}
