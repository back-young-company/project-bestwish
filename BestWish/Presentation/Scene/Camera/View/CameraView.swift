//
//  CameraView.swift
//  BestWish
//
//  Created by Quarang on 6/9/25.
//

import UIKit
import AVFoundation
import SnapKit
import Then

// MARK: - 카메라 뷰
final class CameraView: UIView {
    
    private let onboardingImageView = UIImageView()
    private let onboardingBackgroundView = UIView()
    private let previewBackGroundView = UIView()
    private let homeButton = UIBarButtonItem()
    private let previewLayer = AVCaptureVideoPreviewLayer()     // 실시간 카메라 프리뷰 화면을 보여주는 레이어
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    /// 헤더 뷰의 높이를 계산한 후 카메라 레이어 높이 설정
    override func layoutSubviews() {
        super.layoutSubviews()
        previewBackGroundView.layer.insertSublayer(previewLayer, at: 0)
        previewLayer.frame = CGRect(
            x: 0,
            y: 0,
            width: bounds.width,
            height: previewBackGroundView.bounds.height
        )
    }
    
    // 온보딩 뷰 2초동안 표시
    public func showToast() {
        UIView.animate(withDuration: 0.3, animations: {
            self.onboardingBackgroundView.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 2.0, options: [], animations: {
                self.onboardingBackgroundView.alpha = 0.0
            }) { _ in
                self.onboardingBackgroundView.removeFromSuperview()
            }
        }
    }
    
    func configure() { }
    
    // MARK: - 외부 접근
    public var getPreviewLayer: AVCaptureVideoPreviewLayer { previewLayer }
    public var getHomeButton: UIBarButtonItem { homeButton }
    public var getPreviewBackGroundView: UIView { previewBackGroundView }
}

private extension CameraView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setDelegate()
        setDataSource()
        setBindings()
    }
    
    func setAttributes() {
        
        homeButton.do {
            $0.image = UIImage(systemName: "house")
            $0.tintColor = .black
        }
        
        onboardingBackgroundView.do {
            $0.backgroundColor = .black.withAlphaComponent(0.5)
            $0.alpha = 0
        }
        
        onboardingImageView.do {
            $0.image = UIImage(named: "photo_frame")
            $0.contentMode = .scaleAspectFit
            $0.alpha = 1
        }
    }
    
    func setHierarchy() {
        addSubviews(previewBackGroundView, onboardingBackgroundView)
        onboardingBackgroundView.addSubview(onboardingImageView)
    }
    
    func setConstraints() {
        previewBackGroundView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        onboardingBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        onboardingImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(250)
            $0.height.equalTo(300)
        }
    }
    
    func setDelegate() {
        
    }
    
    func setDataSource() {
        
    }
    
    func setBindings() {
        
    }
}
