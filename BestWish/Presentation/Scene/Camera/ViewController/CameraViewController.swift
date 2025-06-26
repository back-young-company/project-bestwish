//
//  CameraViewController.swift
//  BestWish
//
//  Created by Quarang on 6/9/25.
//

import AVFoundation
import UIKit

import CropViewController
import RxSwift

/// 카메라 뷰 컨트롤러
final class CameraViewController: UIViewController {
    
    // MARK: - Private Property
    private let viewModel = CameraViewModel()
    private let cameraView = CameraView()
    private let disposeBag = DisposeBag()
    
    private var session: AVCaptureSession?                      // 카메라 입력, 출력을 연결하는 세션 객체
    private let output = AVCapturePhotoOutput()                 // 사진 촬영을 담당하는 출력 객체
    private var currentCameraPosition: AVCaptureDevice.Position = .back
    private let globalQueue = DispatchQueue(label: "BestWish.globalQueue", qos: .userInteractive)
    
    // MARK: - Internal Property
    var getHeaderHomeButton: UIBarButtonItem { return cameraView.homeButton }
    
    override func loadView() {
        view = cameraView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar(alignment: .left, title: "라이브 캡쳐")
        navigationItem.rightBarButtonItem = cameraView.homeButton
        bindViewModel()
    }
    
    /// 뷰가 보일 떄마다 이벤트 방출
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.action.onNext(.viewDidLoad)
    }
    
    /// 뷰가 사라질 때마다 카메라 세션 종료 및 삭제
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        globalQueue.async { [weak self] in
            guard let self else { return }
            self.session?.stopRunning()
            self.session = nil
        }
    }
    
    private func bindViewModel() {
        
        viewModel.state.successSetUpCamera
            .subscribe(with: self) { owner, _ in
                owner.setUpCamera()
                owner.cameraView.showToast()
            }
            .disposed(by: disposeBag)
    }
    
    /// 카메라 실행 메서드 (호출 시 레이어에 카메라 화면 추가 및 실시간 카메라 프리뷰 기능)
    private func setUpCamera() {
        
        guard let device = AVCaptureDevice.default(for: .video) else { return }         // 기본 카메라 장비(비디오)로 설정
        
        do {
            let session = AVCaptureSession()                                            // 세션 정의
            let input = try AVCaptureDeviceInput(device: device)                        // 장비를 입력으로 변환
            
            // 세션에 input/output을 추가 가능한지 검사 후 추가
            if session.canAddInput(input) { session.addInput(input) }
            if session.canAddOutput(output) { session.addOutput(output) }
            
            // 프리뷰 레이이어에 세션 설정 및 비율 유지하며 꽉 차게 표시
            cameraView.previewLayer.session = session
            cameraView.previewLayer.videoGravity = .resizeAspectFill
            
            // 카메라 세션 시작
            globalQueue.async { session.startRunning() }
            
            self.session = session
        } catch {
            NSLog("카메라 설정 에러\(error)")
        }
    }
}

// MARK: - 사진 촬영 관련
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    /// 사진 촬영 메서드
    public func didTapTakePhoto() {
        output.capturePhoto(with: .init(), delegate: self)
    }
    
    /// 사진 촬영 후 뷰 계층에 추가
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: (any Error)?) {
        guard let data = photo.fileDataRepresentation(),
              var image = UIImage(data: data)
        else { return }
        
        if currentCameraPosition == .front {
            if let cgImage = image.cgImage {
                image = UIImage(cgImage: cgImage, scale: image.scale, orientation: .leftMirrored)
            }
        }
        
        session?.stopRunning()
        presentImageCropper(with: image)
    }
    
    /// 이미지 크로퍼 뷰 present
    func presentImageCropper(with image: UIImage) {
        guard let imageData = image.pngData() else { return }
        let imageEditVC = DIContainer.shared.makeImageEditController(imageData: imageData)
        imageEditVC.onDismiss = { [weak self] in
            guard let self else { return }
            self.globalQueue.async {
                self.session?.startRunning()
            }
        }
        let navVc = UINavigationController(rootViewController: imageEditVC)
        navVc.modalPresentationStyle = .fullScreen
        present(navVc, animated: false)
    }
    
    /// 화면 전환
    public func switchCamera() {
        guard let session else { return }
        session.beginConfiguration()                                                // 세션에 입력/출력 장치를 변경할 준비를 시작
        if let currentInput = session.inputs.first as? AVCaptureDeviceInput {
            session.removeInput(currentInput)                                       // 현재 세션에 등록된 입력 장치 중 첫 번째를 가져와 세션에서 제거 → 후면 카메라가 연결되어 있다면 끊는 작업
            currentCameraPosition = currentCameraPosition == .back ? .front : .back
            if let newDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: currentCameraPosition),  // 바뀐 카메라 포지션에 맞는 새로운 카메라 장비를 가져옴
               let newInput = try? AVCaptureDeviceInput(device: newDevice),         // 그 장비로 AVCaptureDeviceInput을 생성
               session.canAddInput(newInput) {
                session.addInput(newInput)                                          // 세션에 입력으로 추가 가능한지 확인한 뒤 추가
            }
        }
        session.commitConfiguration()                                               // 시작한 변경 내용을 마무리하고 적용
    }
}


