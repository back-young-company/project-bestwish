//
//  CameraViewController.swift
//  BestWish
//
//  Created by Quarang on 6/9/25.
//

import UIKit
import AVFoundation
import CropViewController

// MARK: - 카메라 뷰 컨트롤러
final class CameraViewController: UIViewController {
    
    private var session: AVCaptureSession?                      // 카메라 입력, 출력을 연결하는 세션 객체
    private let output = AVCapturePhotoOutput()                 // 사진 촬영을 담당하는 출력 객체
    private let cameraView = CameraView()
    private var currentCameraPosition: AVCaptureDevice.Position = .back
    private let globalQueue = DispatchQueue(label: "BestWish.globalQueue", qos: .userInteractive)
    
    override func loadView() {
        view = cameraView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar(alignment: .left, title: "라이브 캡쳐")
        navigationItem.rightBarButtonItem = cameraView.getHomeButton
        checkCameraPermissions()
    }
    
    /// 카메라 권한 확인 로직 메서드
    private func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:                                                        // 처음 실행 시, 사용자에게 권한 요청
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in     // 요청 실패 시 아직 어떠한 이벤트도 넣지 않은 상태
                guard granted else { return }
                self?.setUpCamera()
                self?.cameraView.showToast()
            }
        case .restricted, .denied: break                                            // 사용 제한 상태
        case .authorized:
            setUpCamera()
            cameraView.showToast()
        @unknown default: break                                                     // 이미 허용된 상태
        }
    }
    
    /// 카메라 실행 메서드 (호출 시 레이어에 카메라 화면 추가 및 실시간 카메라 프리뷰 기능)
    private func setUpCamera() {
        let session = AVCaptureSession()                                                // 세션 정의
        guard let device = AVCaptureDevice.default(for: .video) else { return }         // 기본 카메라 장비(비디오)로 설정
        
        do {
            let input = try AVCaptureDeviceInput(device: device)                        // 장비를 입력으로 변환
            
            // 세션에 input/output을 추가 가능한지 검사 후 추가
            if session.canAddInput(input) { session.addInput(input) }
            if session.canAddOutput(output) { session.addOutput(output) }
            
            // 프리뷰 레이이어에 세션 설정 및 비율 유지하며 꽉 차게 표시
            cameraView.getPreviewLayer.session = session
            cameraView.getPreviewLayer.videoGravity = .resizeAspectFill
            
            // 카메라 세션 시작
            globalQueue.async { session.startRunning() }
            
            self.session = session
        } catch {
            print("카메라 설정 에러\(error)")
        }
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
    
    // MARK: 외부에서 접근 가능
    public var getHeaderHomeButton: UIBarButtonItem { return cameraView.getHomeButton }
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
}

// MARK: - 이미지 가공 관련
extension CameraViewController: CropViewControllerDelegate {
    /// 이미지 크로퍼 뷰 present
    func presentImageCropper(with image: UIImage) {
//        let vc = UINavigationController(rootViewController: ImageEditViewController(image: image))
//        (vc.viewControllers.first as? ImageEditViewController)?.getImageEditView.getCropperVC.delegate = self
        let vc = ImageEditViewController(image: image)
        vc.getCropperVC.delegate = self
        let navVc = UINavigationController(rootViewController: vc)
        navVc.modalPresentationStyle = .fullScreen
        present(navVc, animated: false)
    }
    
    /// 크롭 이미지 뷰 완료  버튼 호출 시
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        print(image)
    }
    /// 크롭 이미지 뷰 취소 버튼 호출 시
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true) {
            self.globalQueue.async { [weak self] in
                self?.session?.startRunning()
            }
        }
    }
}
