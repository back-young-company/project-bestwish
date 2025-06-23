//
//  CameraViewModel.swift
//  BestWish
//
//  Created by Quarang on 6/23/25.
//

import AVFoundation
import RxSwift
import RxRelay
import UIKit

// MARK: - 이미지 편집 뷰 모델
final class CameraViewModel: ViewModel {
    
    private let disposeBag = DisposeBag()

    enum Action {
        case viewDidLoad
    }

    struct State {
        let successSetUpCamera: Observable<Void>
    }

    private let _action = PublishSubject<Action>()
    var action: AnyObserver<Action> { _action.asObserver() }

    private let _successSetUpCamera = PublishSubject<Void>()
    let state: State

    init() {
        state = State(successSetUpCamera: _successSetUpCamera.asObserver())
        bindAction()
        
    }

    private func bindAction() {
        _action.subscribe(with: self) { owner, action in
            switch action {
            case .viewDidLoad:
                owner.checkCameraPermissions()
            }
        }.disposed(by: disposeBag)
    }
}

private extension CameraViewModel {
    
    /// 카메라 권한 확인 로직 메서드
    func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:                                                        // 처음 실행 시, 사용자에게 권한 요청
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in     // 요청 실패 시 아직 어떠한 이벤트도 넣지 않은 상태
                guard granted, let self else { return }
                
                DispatchQueue.main.async {
                    self._successSetUpCamera.onNext(())
                }
            }
        case .restricted, .denied: break                                            // 사용 제한 상태
        case .authorized:
            DispatchQueue.main.async {
                self._successSetUpCamera.onNext(())
            }
        @unknown default: break                                                     // 이미 허용된 상태
        }
    }
}
