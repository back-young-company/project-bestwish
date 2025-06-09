//
//  CameraViewController.swift
//  BestWish
//
//  Created by Quarang on 6/9/25.
//

import AVFoundation
import UIKit

final class CameraViewController: UIViewController {
    
    var session: AVCaptureSession?                      // 카메라 입력, 출력을 연결하는 세션 객체
    let output = AVCapturePhotoOutput()                 // 사진 촬영을 담당하는 출력 객체
    let preivewLayer = AVCaptureVideoPreviewLayer()     // 실시간 카메라 프리뷰 화면을 보여주는 레이어
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCameraPermissions()                        // 뷰가 올라온 직후, 카메라 권한 확인 로직 실행
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.addSublayer(preivewLayer)
        preivewLayer.frame = view.bounds
    }
    
    private func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        // 처음 실행 시, 사용자에게 권한 요청
        case .notDetermined:
           // 요청
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                self?.setUpCamera()
            }
        // 사용 제한 상태
        case .restricted:
            break
        case .denied:
            break
        // 이미 허용된 상태
        case .authorized:
            setUpCamera()
        @unknown default:
            break
        }
    }
    
    /// 카메라 실행 메서드 (호출 시 레이어에 카메라 화면 추가 및 실시간 카메라 프리뷰 기능)
    private func setUpCamera() {
        let session = AVCaptureSession()                                // 세션 정의
        if let device = AVCaptureDevice.default(for: .video) {          // 기본 카메라 장비(비디오)로 설정
            do {
                let input = try AVCaptureDeviceInput(device: device)    // 장비를 입력으로 변환
                
                // 세션에 input/output을 추가 가능한지 검사 후 추가
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                
                // 프리뷰 레이이어에 세션 설정 및 비율 유지하며 꽉 차게 표시
                preivewLayer.session = session
                preivewLayer.videoGravity = .resizeAspectFill
                
                // 카메라 세션 시작
                DispatchQueue.global(qos: .userInitiated).async {
                    session.startRunning()
                }
                
                self.session = session
            } catch {
                print("카메라 설정 에러\(error)")
            }
        }
    }
    
    /// 사진 촬영 메서드
    public func didTapTakePhoto() {
        output.capturePhoto(with: .init(), delegate: self)
    }
    
}


extension CameraViewController: AVCapturePhotoCaptureDelegate {
    /// 사진 촬영 후 뷰 계층에 추가
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: (any Error)?) {
        guard let data = photo.fileDataRepresentation() else { return }
        let image = UIImage(data: data)
        let imageView = UIImageView(image: image)
        
        session?.stopRunning()
        
        imageView.contentMode = .scaleAspectFill
        imageView.frame = view.bounds
        view.addSubview(imageView)
        
    }
}
