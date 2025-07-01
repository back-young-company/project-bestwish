//
//  ImageEditView.swift
//  BestWish
//
//  Created by Quarang on 6/11/25.
//

import UIKit

internal import CropViewController
internal import SnapKit
internal import Then
import TOCropViewController

/// 이미지 편집 뷰
final class ImageEditView: UIView {

    // MARK: - Private Property
    private let _doneButton = AppButton(type: .next)
    private let _cancelButton = AppButton(type: .cancel)
    private let _headerLabel = UILabel()
    private let _cropperBackgroundView = UIView()
    private let _cropView: UIView
    private let _toolbar: TOCropToolbar
    
    // MARK: - Internal Property
    var doneButton: UIButton { _doneButton }
    var cancelButton: UIButton { _cancelButton }
    var cropperBackgroundView: UIView { _cropperBackgroundView }
    
    init(_cropView: UIView, _toolbar: TOCropToolbar) {
        self._toolbar = _toolbar
        self._cropView = _cropView
        super.init(frame: .zero)

        setView()
    }
    
    override func layoutSubviews() {
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - 이미지 에딧 뷰 설정
private extension ImageEditView {
    func setView() {
        setAttributes()
        setHierarchy()
    }
    
    func setAttributes() {
        backgroundColor = .gray0

        _toolbar.rotateClockwiseButton?.setImage(UIImage(named: "image_right"), for: .normal)
        _toolbar.rotateButton.setImage(UIImage(named: "image_left"), for: .normal)
        
        _toolbar.resetButton.setImage(UIImage(named: "image_init_de"), for: .normal)
        _toolbar.resetButton.setImage(UIImage(named: "image_init_se"), for: .selected)
        
        _toolbar.clampButton.setImage(UIImage(named: "image_ratio_de"), for: .normal)
        _toolbar.clampButton.setImage(UIImage(named: "image_ratio_se"), for: .selected)
        
        _cropperBackgroundView.do {
            $0.backgroundColor = .black.withAlphaComponent(0.9)
        }
        
        _headerLabel.do {
            $0.text = "이미지 편집"
            $0.textColor = .init(hex: "#201D20")
            $0.font = .font(.pretendardBold, ofSize: 18)
        }
        
        _doneButton.do {
            $0.setTitle("분석하기", for: .normal)
            $0.setTitleColor(.gray0, for: .normal)
        }
        
        _cancelButton.do {
            $0.setTitle("뒤로", for: .normal)
            $0.setTitleColor(.gray, for: .normal)
        }
    }
    
    func setHierarchy() {
        addSubviews(_cropperBackgroundView, _cancelButton, _doneButton, _headerLabel)
    }
    
    func setConstraints() {
        
        _headerLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(10)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(18)
        }
        
        _cropperBackgroundView.snp.makeConstraints {
            $0.top.equalTo(_headerLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(_doneButton.snp.top).offset(-20)
        }
        
        _cropView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
        }
        
        _cancelButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(80)
            $0.height.equalTo(53)
        }
        
        _doneButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            $0.leading.equalTo(_cancelButton.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(53)
        }
    }
}
