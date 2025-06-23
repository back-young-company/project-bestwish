//
//  CameraViewModel.swift
//  BestWish
//
//  Created by Quarang on 6/11/25.
//

import RxSwift
import RxRelay
import UIKit

// MARK: - 이미지 편집 뷰 모델
final class ImageEditViewModel: ViewModel {
    
    private let coreMLUseCase: CoreMLUseCase
    private let disposeBag = DisposeBag()

    enum Action {
        case didTapDoneButton(UIImage)
    }

    struct State {
        let labelData: Observable<[LabelDataDisplay]>
    }

    private let _action = PublishSubject<Action>()
    var action: AnyObserver<Action> { _action.asObserver() }

    private let _labelData = PublishSubject<[LabelDataDisplay]>()
    let state: State

    init(coreMLUseCase: CoreMLUseCase) {
        self.coreMLUseCase = coreMLUseCase
        state = State(labelData: _labelData.asObservable())

        bindAction()
    }

    private func bindAction() {
        _action.subscribe(with: self) { owner, action in
            switch action {
            case let .didTapDoneButton(image):
                owner.imageAnalaysis(image: image)
            }
        }.disposed(by: disposeBag)
    }
}

private extension ImageEditViewModel {
    /// 이미지 분석 후 라벨 데이터 추출
    func imageAnalaysis(image: UIImage) {

        do {
            let labels = try coreMLUseCase.fetchLabelDataModel(image: image).map {
                LabelDataDisplay.convertToDisplay(from: $0)
            }
            _labelData.onNext(labels)
        } catch let error {
            guard let error = error as? AppError else {
                _labelData.onError(AppError.unknown(error))
                return
            }
            _labelData.onError(error)
        }
    }
}
