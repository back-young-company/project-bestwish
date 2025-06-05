//
//  DummyViewModel.swift
//  BestWish
//
//  Created by 이수현 on 6/4/25.
//

import RxSwift
import RxRelay

final class DummyViewModel: ViewModel {
    private let dummyUseCase: DummyUseCase
    private let disposeBag = DisposeBag()

    enum Action {
        case viewDidLoad(Void)
    }

    struct State {
        let data: Observable<DummyDisplay>
        let newData: Observable<DummyDisplay>
        let error: Observable<Error>
    }

    private let _action = PublishSubject<Action>()
    var action: AnyObserver<Action> { _action.asObserver() }

    private let _data = PublishSubject<DummyDisplay>()
    private let _newData = PublishSubject<DummyDisplay>()
    private let _error = PublishSubject<Error>()
    let state: State

    init(dummyUseCase: DummyUseCase) {
        self.dummyUseCase = dummyUseCase

        state = State(
            data: _data.asObservable(),
            newData: _newData.asObservable(),
            error: _error.asObservable()
        )

        bindAction()
    }

    private func bindAction() {
        _action.subscribe(with: self) { owner, action in
            switch action {
            case .viewDidLoad:
                owner.fetchDummyData()
            }
        }.disposed(by: disposeBag)
    }

    private func fetchDummyData() {
        Task {
            do {
                let result = try await dummyUseCase.fetchDummy()
                let display = DummyDisplay.convertToDisplay(from: result)
                _data.onNext(display)
            } catch {
                _error.onNext(error)
            }
        }
    }
}

extension DummyViewModel {
    func convertToDisplay(from model: Dummy) -> DummyDisplay {
        let price = "\(Int(model.price).formatted(.currency(code: "KRW")))원"
        return DummyDisplay(title: model.title, price: price)
    }
}
