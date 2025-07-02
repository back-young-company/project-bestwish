//
//  CameraFlowDelegate.swift
//  BestWishPresentation
//
//  Created by 이수현 on 7/2/25.
//

import AVFoundation
import Foundation

/// 카메라 화면 이동 플로우
public protocol CameraFlowDelegate: AnyObject {
    /// 이미지 크로퍼 뷰 present
    func presentImageCropper(
        imageData: Data,
        session: AVCaptureSession?,
        queue: DispatchQueue
    ) 
}
