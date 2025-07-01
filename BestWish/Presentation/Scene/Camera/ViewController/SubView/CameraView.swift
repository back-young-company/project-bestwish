//
//  CameraView.swift
//  BestWish
//
//  Created by Quarang on 6/9/25.
//

import AVFoundation
import UIKit

import SnapKit
import Then

/// 카메라 뷰
final class CameraView: UIView {
    
    // MARK: - Private Property
    private let _onboardingImageView = UIImageView()
    private let _onboardingBackgroundView = UIView()
    private let _previewBackGroundView = UIView()
    private let _homeButton = UIBarButtonItem()
    private let _previewLayer = AVCaptureVideoPreviewLayer()     // 실시간 카메라 프리뷰 화면을 보여주는 레이어
    
    // MARK: - Internal Property
    var previewLayer: AVCaptureVideoPreviewLayer { _previewLayer }
    var homeButton: UIBarButtonItem { _homeButton }
    var previewBackGroundView: UIView { _previewBackGroundView }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    /// 헤더 뷰의 높이를 계산한 후 카메라 레이어 높이 설정
    override func layoutSubviews() {
        super.layoutSubviews()
        _previewBackGroundView.layer.insertSublayer(_previewLayer, at: 0)
        _previewLayer.frame = CGRect(
            x: 0,
            y: 0,
            width: bounds.width,
            height: _previewBackGroundView.bounds.height
        )
    }
    
    /// 회원가입 뷰 2초동안 표시
    public func showToast() {
        UIView.animate(withDuration: 0.3, animations: {
            self._onboardingBackgroundView.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 2.0, options: [], animations: {
                self._onboardingBackgroundView.alpha = 0.0
            }) { _ in
                self._onboardingBackgroundView.removeFromSuperview()
            }
        }
    }
}

// MARK: - 카메라 뷰 설정
private extension CameraView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }
    
    func setAttributes() {
        
        _homeButton.do {
            $0.image = UIImage(named: "home_button")?.resize(to: CGSize(width: CGFloat(20).fitWidth, height: CGFloat(20).fitHeight))
            $0.tintColor = .black
        }
        
        _onboardingBackgroundView.do {
            $0.backgroundColor = .black.withAlphaComponent(0.5)
            $0.alpha = 0
        }
        
        _onboardingImageView.do {
            $0.image = UIImage(named: "photo_frame")
            $0.contentMode = .scaleAspectFit
            $0.alpha = 1
        }
    }
    
    func setHierarchy() {
        addSubviews(_previewBackGroundView, _onboardingBackgroundView)
        _onboardingBackgroundView.addSubview(_onboardingImageView)
    }
    
    func setConstraints() {
        _previewBackGroundView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        _onboardingBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        _onboardingImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(CGFloat(250).fitWidth)
            $0.height.equalTo(CGFloat(300).fitWidth)
        }
    }
}
