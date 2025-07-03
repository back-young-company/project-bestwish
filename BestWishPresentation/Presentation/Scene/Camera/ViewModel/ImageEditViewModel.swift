//
//  CameraViewModel.swift
//  BestWish
//
//  Created by Quarang on 6/11/25.
//

import BestWishDomain
import Foundation

internal import RxSwift
internal import RxRelay

/// 이미지 편집 뷰 모델
public final class ImageEditViewModel: ViewModel {

    // MARK: - Action
    enum Action {
        case didTapDoneButton(imageData: Data)
    }

    // MARK: - State
    struct State {
        let labelData: Observable<[LabelDataEntity]>
    }

    // MARK: - Internal Property
    var action: AnyObserver<Action> { _action.asObserver() }
    let state: State
    
    // MARK: - Private Property
    private let _action = PublishSubject<Action>()
    private let _labelData = PublishSubject<[LabelDataEntity]>()

    private let coreMLUseCase: CoreMLUseCase
    private let disposeBag = DisposeBag()
    
    public init(coreMLUseCase: CoreMLUseCase) {
        self.coreMLUseCase = coreMLUseCase
        state = State(labelData: _labelData.asObservable())

        bindAction()
    }

    private func bindAction() {
        _action.subscribe(with: self) { owner, action in
            switch action {
            case let .didTapDoneButton(imageData):
                owner.imageAnalysis(imageData: imageData)
            }
        }.disposed(by: disposeBag)
    }
}

// MARK: - 비즈니스 로직
private extension ImageEditViewModel {
    /// 이미지 분석 후 라벨 데이터 추출
    func imageAnalysis(imageData: Data) {
        do {
            let labels = try coreMLUseCase.fetchLabelDataModel(imageData: imageData)
            _labelData.onNext(labels)
        } catch let error {
            guard let error = error as? AppError else {
                _labelData.onError(error)
                return
            }
            _labelData.onError(error)
        }
    }
}
