//
//  CameraViewModel.swift
//  BestWish
//
//  Created by Quarang on 6/23/25.
//

import AVFoundation
import UIKit

internal import RxRelay
internal import RxSwift

/// 이미지 편집 뷰 모델
final class CameraViewModel: ViewModel {
    
    // MARK: - Action
    enum Action {
        case viewDidLoad
    }
    
    // MARK: - State
    struct State {
        let successSetUpCamera: Observable<Void>
    }
    
    // MARK: - Internal Property
    var action: AnyObserver<Action> { _action.asObserver() }
    let state: State
    
    // MARK: - Private Property
    private let _action = PublishSubject<Action>()
    
    private let _successSetUpCamera = PublishSubject<Void>()
    
    private let disposeBag = DisposeBag()

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

// MARK: - 비즈니스 로직
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
