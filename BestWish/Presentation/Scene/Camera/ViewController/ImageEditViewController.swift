//
//  CustomCropViewController.swift
//  BestWish
//
//  Created by Quarang on 6/10/25.
//

import UIKit
import Then
import RxSwift
import RxCocoa
import SnapKit
import CropViewController

final class ImageEditViewController: UIViewController {
    
    let a = UIButton()
    var cropperView: CropViewController
    var d = DisposeBag()
    
    init(image: UIImage) {
        cropperView = CropViewController(image: image)
        super.init(nibName: nil, bundle: nil)
        
        cropperView.doneButtonHidden = true
        cropperView.cancelButtonHidden = true
//        doneButtonTitle = "완료"
//        cancelButtonTitle = "취소"
        cropperView.aspectRatioLockEnabled = true
        cropperView.resetButtonHidden = false
        cropperView.aspectRatioPickerButtonHidden = false
        
        
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(cropperView.view, a)
        
        cropperView.view.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(a.snp.top)
        }
        a.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(44)
        }
        
        cropperView.toolbar.doneTextButton.do {
            $0.backgroundColor = .red
        }
        cropperView.toolbar.clampButton.setImage(UIImage(named: "home_de1"), for: .normal)
        
        a.do {
            $0.setImage(UIImage(systemName: "star"), for: .normal)
            $0.backgroundColor = .yellow
            $0.tintColor = .black
        }
        
        a.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                print("눌림")
                owner.cropperView.delegate?.cropViewController?(
                    owner.cropperView,
                    didCropToImage: owner.cropperView.cropView.image,
                    withRect: owner.cropperView.cropView.imageCropFrame,
                    angle: owner.cropperView.angle
                )
                owner.dismiss(animated: true)
            }
            ).disposed(by: d)
    }
}
