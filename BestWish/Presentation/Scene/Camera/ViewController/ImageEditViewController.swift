//
//  CustomCropViewController.swift
//  BestWish
//
//  Created by Quarang on 6/10/25.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - 이미지 편집 뷰 컨트롤러
final class ImageEditViewController: UIViewController {
    
    private let imageEditView: ImageEditView
    var disposeBag = DisposeBag()
    
    init(image: UIImage) {
        imageEditView = ImageEditView(image: image)
        super.init(nibName: nil, bundle: nil)
        
    }
    override func loadView() {
        view = imageEditView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindView()
    }
    
    private func bindView() {
        // 분석하기 버튼 터치
        imageEditView.getDoneButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let vc = owner.imageEditView.getCropperVC
                vc.delegate?.cropViewController?(vc, didCropToImage: vc.image, withRect: vc.imageCropFrame, angle: vc.angle)
            }
            .disposed(by: disposeBag)
        
        // 뒤로가기 버튼 터치
        imageEditView.getCancelButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let vc = owner.imageEditView.getCropperVC
                vc.delegate?.cropViewController?(vc, didFinishCancelled: true)
                owner.dismiss(animated: false)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - 외부 접근
    var getImageEditView: ImageEditView { imageEditView }
}
