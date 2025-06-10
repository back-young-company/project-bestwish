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
    
    private let headerView = UIView()
    private let headerTitleLabel = UILabel()
    private let headerHomeButton = UIButton()
    
    private let preivewLayer = AVCaptureVideoPreviewLayer()     // 실시간 카메라 프리뷰 화면을 보여주는 레이어
    
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
        layer.addSublayer(preivewLayer)
        
        let headerHeight = headerView.frame.height
        preivewLayer.frame = CGRect(
            x: 0,
            y: headerHeight,
            width: bounds.width,
            height: bounds.height - headerHeight
        )
    }
    
    func configure() { }
    
    // MARK: - 외부 접근
    public var getPreviewLayer: AVCaptureVideoPreviewLayer { return preivewLayer }
    public var getHeaderHomeButton: UIButton { return headerHomeButton }
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
        headerTitleLabel.do {
            $0.text = "라이브 캡쳐"
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 20, weight: .bold)
        }
        
        headerHomeButton.do {
            $0.setImage(UIImage(systemName: "house"), for: .normal)
            $0.imageView?.tintColor = .black
        }
        
        headerView.do {
            $0.backgroundColor = .white
        }
    }
    
    func setHierarchy() {
        addSubview(headerView)
        headerView.addSubviews(headerTitleLabel, headerHomeButton)
    }
    
    func setConstraints() {
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        headerTitleLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(20)
        }
        
        headerHomeButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    func setDelegate() {
        
    }
    
    func setDataSource() {
        
    }
    
    func setBindings() {
        
    }
}

