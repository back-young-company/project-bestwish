//
//  CustomCropViewController.swift
//  BestWish
//
//  Created by Quarang on 6/10/25.
//

import UIKit
import RxSwift
import RxCocoa
import CropViewController

// MARK: - 이미지 편집 뷰 컨트롤러
final class ImageEditViewController: UIViewController {
    
    private let imageEditView: ImageEditView
    private let cropperVC: CropViewController
    
    var onDismiss: (()-> Void)?
    var disposeBag = DisposeBag()
    
    init(image: UIImage) {
        cropperVC = CropViewController(image: image)
        imageEditView = ImageEditView(cropView: cropperVC.view, toolbar: cropperVC.toolbar)
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
//        setNavigationBar(alignment: .left, title: "이미지 편집")
        setCropViewController()
        setDelegate()
        bindView()
    }
    
    func setDelegate() {
        cropperVC.delegate = self
    }
    
    /// 크롭 뷰 필요 데이터 설정
    func setCropViewController() {
        cropperVC.doneButtonHidden = true
        cropperVC.cancelButtonHidden = true
        cropperVC.aspectRatioLockEnabled = true
        cropperVC.resetButtonHidden = false
        cropperVC.aspectRatioPickerButtonHidden = false
        
        addChild(cropperVC)
        imageEditView.getCropperBackgroundView.addSubview(cropperVC.view)
        cropperVC.didMove(toParent: self)
    }
    
    private func bindView() {
        // 분석하기 버튼 터치
        imageEditView.getDoneButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let vc = owner.cropperVC
                vc.delegate?.cropViewController?(vc, didCropToImage: vc.image, withRect: vc.imageCropFrame, angle: vc.angle)
            }
            .disposed(by: disposeBag)
        
        // 뒤로가기 버튼 터치
        imageEditView.getCancelButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let vc = owner.cropperVC
                vc.delegate?.cropViewController?(vc, didFinishCancelled: true)
                owner.dismiss(animated: false)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - 이미지 가공 관련
extension ImageEditViewController: CropViewControllerDelegate {
    
    /// 크롭 이미지 뷰 완료  버튼 호출 시
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
    }
    /// 크롭 이미지 뷰 취소 버튼 호출 시
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: onDismiss)
    }
}
