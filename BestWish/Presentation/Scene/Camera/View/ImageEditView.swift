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
import TOCropViewController

// MARK: - 이미지 편집 뷰
final class ImageEditView: UIView {
    
    private let doneButton = AppButton(type: .next)
    private let cancelButton = AppButton(type: .cancel)
    private let headerLabel = UILabel()
    private let cropperBackgroundView = UIView()
    private let cropView: UIView
    private let toolbar: TOCropToolbar
    
    init(cropView: UIView, toolbar: TOCropToolbar) {
        self.toolbar = toolbar
        self.cropView = cropView
        super.init(frame: .zero)
        
        setView()
    }
    
    override func layoutSubviews() {
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - 외부 접근 가능
    var getDoneButton: UIButton { doneButton }
    var getCancelButton: UIButton { cancelButton }
    var getCropperBackgroundView: UIView { cropperBackgroundView }
}

private extension ImageEditView {
    func setView() {
        setAttributes()
        setHierarchy()
        setDelegate()
        setDataSource()
        setBindings()
    }
    
    func setAttributes() {
        backgroundColor = .white
        
        toolbar.rotateClockwiseButton?.setImage(UIImage(named: "image_right"), for: .normal)
        toolbar.rotateButton.setImage(UIImage(named: "image_left"), for: .normal)
        
        toolbar.resetButton.setImage(UIImage(named: "image_init_de"), for: .normal)
        toolbar.resetButton.setImage(UIImage(named: "image_init_se"), for: .selected)
        
        toolbar.clampButton.setImage(UIImage(named: "image_ratio_de"), for: .normal)
        toolbar.clampButton.setImage(UIImage(named: "image_ratio_se"), for: .selected)
        
        cropperBackgroundView.do {
            $0.backgroundColor = .black.withAlphaComponent(0.9)
        }
        
        headerLabel.do {
            $0.text = "이미지 편집"
            $0.textColor = .init(hex: "#201D20")
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
        
        cropView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
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
