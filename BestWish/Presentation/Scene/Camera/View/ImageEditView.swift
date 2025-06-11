//
//  ImageEditView.swift
//  BestWish
//
//  Created by Quarang on 6/11/25.
//

import UIKit
import Then
import SnapKit
import CropViewController

// MARK: - 이미지 편집 뷰
final class ImageEditView: UIView {
    
    private let doneButton = AppButton(type: .next)
    private let cancelButton = AppButton(type: .cancel)
    private let headerLabel = UILabel()
    private let cropperBackgroundView = UIView()
    private let cropperVC: CropViewController
    
    var cropperView: UIView { cropperVC.view }
    
    init(image: UIImage) {
        cropperVC = CropViewController(image: image)
        super.init(frame: .zero)
        
        setView()
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    /// 크롭 뷰 필요 데이터 설정
    func configure() {
        cropperVC.doneButtonHidden = true
        cropperVC.cancelButtonHidden = true
        cropperVC.aspectRatioLockEnabled = true
        cropperVC.resetButtonHidden = false
        cropperVC.aspectRatioPickerButtonHidden = false
    }
    
    // MARK: - 외부 접근 가능
    var getDoneButton: UIButton { doneButton }
    var getCancelButton: UIButton { cancelButton }
    var getCropperVC: CropViewController { cropperVC }
    var getCropperBackgroundView: UIView { cropperBackgroundView }
}

private extension ImageEditView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setDelegate()
        setDataSource()
        setBindings()
    }
    
    func setAttributes() {
        backgroundColor = .white
        
//        cropperVC.toolbar.clampButton.setImage(UIImage(named: "home_de1"), for: .normal)
        headerLabel.do {
            $0.text = "이미지 편집"
            $0.font = .font(.pretendardBold, ofSize: 18)
        }
        
        doneButton.do {
            $0.setTitle("분석하기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
        }
        
        cancelButton.do {
            $0.setTitle("뒤로", for: .normal)
            $0.setTitleColor(.gray, for: .normal)
        }
    }
    
    func setHierarchy() {
        addSubviews(cropperBackgroundView, cancelButton, doneButton, headerLabel)
        cropperBackgroundView.addSubview(cropperView)
    }
    
    func setConstraints() {
        
        headerLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(10)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(18)
        }
        
        cropperBackgroundView.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(doneButton.snp.top).offset(-20)
        }
        
        cropperView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(80)
            $0.height.equalTo(60)
        }
        
        doneButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            $0.leading.equalTo(cancelButton.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }
    }
    
    func setDelegate() {
        
    }
    
    func setDataSource() {
        
    }
    
    func setBindings() {
        
    }
}
