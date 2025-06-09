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
        let sections: Observable<[MyPageSection]>
        let userInfo: Observable<AccountDisplay>
    }

    private let _action = PublishSubject<Action>()
    var action: AnyObserver<Action> { _action.asObserver() }

    let state: State

    init() {
        let sections = Observable.just(
            MyPageSectionType.allCases.map({ type in
                switch type {
                case .userAccount:
                    MyPageSection(header: nil, items: [])
                case .userInfo:
                    MyPageSection(header: type.title, items: type.cell.map {
                        MyPageCellItem.seeMore(type: $0)
                    })
                case .help, .setting:
                    MyPageSection(header: type.title, items: type.cell.map {
                        MyPageCellItem.basic(type: $0)
                    })
                }
            })
        )

        let userInfo = Observable.just(
            AccountDisplay(
                profileImageName: "person.crop.circle",
                nickname: "User",
                email: "user@gmail.com"
            )
        )

        state = State(sections: sections, userInfo: userInfo)

        bindAction()
    }

    private func bindAction() {
    }
}
