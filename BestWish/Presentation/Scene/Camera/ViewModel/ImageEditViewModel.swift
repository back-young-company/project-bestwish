//
//  CameraViewModel.swift
//  BestWish
//
//  Created by Quarang on 6/11/25.
//

import RxSwift
import RxRelay
import CoreML
import UIKit

// MARK: - 이미지 편집 뷰 모델
final class ImageEditViewModel: ViewModel {
    
    let model = try? BestWidhClassfication()
    private let dummyUseCase: DummyUseCase
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

    init(dummyUseCase: DummyUseCase) {
        self.dummyUseCase = dummyUseCase
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
        guard let model = model,
              let buffer = image.toCVPixelBuffer() else { return }

        do {
            let output = try model.prediction(image: buffer)
            let labels = output.targetProbability
                .sorted(by: { $0.value > $1.value })
                .map {
                    let label = LabelData(label: $0.key, probability: Int($0.value * 100))
                    return LabelDataDisplay.convertToDisplay(from: label)
                }
            _labelData.onNext(labels)
        } catch {
            print("예측 실패:", error)
        }
    }
}
