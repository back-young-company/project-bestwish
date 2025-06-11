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

final class ImageEditView: UIView {
    
    private let doneButton = UIButton()
    private let cancelButton = UIButton()
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
    var getCropperVC: CropViewController { cropperVC }
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
        
        cropperVC.toolbar.do {
            $0.statusBarHeightInset = 0
            $0.backgroundViewOutsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        }
        
        doneButton.do {
            $0.setTitle("완료", for: .normal)
            $0.setTitleColor(.black, for: .normal)
        }
        
        cancelButton.do {
            $0.setTitle("취소", for: .normal)
            $0.setTitleColor(.black, for: .normal)
        }
    }
    
    func setHierarchy() {
        addSubviews(cropperView, cancelButton, doneButton)
    }
    
    func setConstraints() {
        
//        cropperVC.toolbar.snp.makeConstraints {
//            $0.bottom.equalToSuperview()
//            $0.height.equalTo(80) // 원하는 높이
//            $0.horizontalEdges.equalToSuperview()
//        }
        
        cropperView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(doneButton.snp.top)
        }
        
        doneButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(44)
        }
        
        cancelButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.width.height.equalTo(44)
        }
    }
    
    func setDelegate() {
        
    }
    
    func setDataSource() {
        
    }
    
    func setBindings() {
        
    }
}
