//
//  OnboardingViewModel.swift
//  BestWish
//
//  Created by yimkeul on 6/30/25.
//

import RxRelay
import RxSwift

/// 이용약관 ViewModel
final class OnboardingViewModel: ViewModel {

    // MARK: - Actions
    enum Action {
        case viewDidLoad
        case didTapNextPage
        case didScrollToPage(Int)
    }

    // MARK: - States
    struct State {
        let currentPage: Observable<Int>
        let pages: Observable<[OnboardingDataInfo]>
    }

    // MARK: - Internal Property
    var action: AnyObserver<Action> { _action.asObserver() }
    let state: State


    // MARK: - Private Property
    private let _action = PublishSubject<Action>()

    private let _currentPage = BehaviorRelay<Int>(value: 0)
    private let _pages = PublishRelay<[OnboardingDataInfo]>()
    private let disposeBag = DisposeBag()

    init() {
        state = State(
            currentPage: _currentPage.asObservable(),
            pages: _pages.asObservable()
        )
        bindAction()
    }

    private func bindAction() {
        _action
            .subscribe(with: self) { owner, action in
            switch action {
            case .viewDidLoad:
                let pages = OnboardingData.allCases.map { $0.value }
                self._pages.accept(pages)

            case .didTapNextPage:
                // 버튼을 눌러서 넘어온 경우
                let next = min(owner._currentPage.value + 1, 4)
                owner._currentPage.accept(next)

            case .didScrollToPage(let index):
                // 스크롤로 넘어온 경우
                let next = min(max(index, 0), 4)
                owner._currentPage.accept(next)
            }
        }
            .disposed(by: disposeBag)
    }


}
