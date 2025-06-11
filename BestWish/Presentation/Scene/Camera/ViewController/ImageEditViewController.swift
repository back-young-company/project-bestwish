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
    
    
    private let imageEditView: ImageEditView
    var d = DisposeBag()
    
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
        
        imageEditView.getDoneButton.rx.tap
            .subscribe(with: self) { owner, _ in
                print("눌림")
                let vc = owner.imageEditView.getCropperVC
                vc.delegate?.cropViewController?(vc, didCropToImage: vc.image, withRect: vc.imageCropFrame, angle: vc.angle)
                owner.dismiss(animated: true)
            }
            .disposed(by: d)
    }
    
    // MARK: - 외부 접근
    var getImageEditView: ImageEditView { imageEditView }
}
