//
//  CustomCropViewController.swift
//  BestWish
//
//  Created by Quarang on 6/10/25.
//

import BestWishDomain
import UIKit

public import CropViewController
internal import RxCocoa
internal import RxSwift

/// 이미지 편집 뷰 컨트롤러
public final class ImageEditViewController: UIViewController {

    public weak var flowDelegate: ImageEditFlowDelegate?

    // MARK: - Private Property
    private let imageEditView: ImageEditView
    private let cropperVC: CropViewController
    private let viewModel: ImageEditViewModel
    
    // MARK: - Internal Property
    public var onDismiss: (()-> Void)?
    var disposeBag = DisposeBag()
    
    public init(imageData: Data, viewModel: ImageEditViewModel) {

        self.viewModel = viewModel
        if let image = UIImage(data: imageData) {
            cropperVC = CropViewController(image: image)
        } else {
            cropperVC = CropViewController(image: UIImage())
        }
        
        imageEditView = ImageEditView(_cropView: cropperVC.view, _toolbar: cropperVC.toolbar)
        super.init(nibName: nil, bundle: nil)
        
    }
    
    public override func loadView() {
        view = imageEditView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
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
        imageEditView.cropperBackgroundView.addSubview(cropperVC.view)
        cropperVC.didMove(toParent: self)
    }
    
    private func bindView() {
        // 분석하기 버튼 터치
        imageEditView.doneButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let vc = owner.cropperVC
                vc.delegate?.cropViewController?(vc, didCropToImage: vc.image, withRect: vc.imageCropFrame, angle: vc.angle)
            }
            .disposed(by: disposeBag)
        
        // 뒤로가기 버튼 터치
        imageEditView.cancelButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let vc = owner.cropperVC
                vc.delegate?.cropViewController?(vc, didFinishCancelled: true)
                owner.flowDelegate?.didTapCancelButton()
//                owner.dismiss(animated: false)
            }
            .disposed(by: disposeBag)
        
        // 라벨 데이터 요청
        viewModel.state.labelData
            .subscribe(with: self, onNext: { owner, labelData in
                owner.flowDelegate?.didSetLabelData(labelData: labelData)
//                let vc = DIContainer.shared.makeAnalysisViewController(labelData: labelData)
//                if let sheet = vc.sheetPresentationController {
//                    sheet.detents = [
//                        .medium(),
//                        .custom(identifier: .init("mini")) { context in
//                            return context.maximumDetentValue * 0.22
//                        }
//                    ]
//                    sheet.selectedDetentIdentifier = .medium
//                    sheet.prefersGrabberVisible = true
//                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
//                }
//                vc.modalPresentationStyle = .pageSheet
//                owner.present(vc, animated: true)
            }) { owner, error in
                guard let error = error as? AppError else { return }
                NSLog(error.errorDescription ?? "")
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - 이미지 가공 관련
extension ImageEditViewController: CropViewControllerDelegate {

    /// 크롭 이미지 뷰 완료  버튼 호출 시
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        guard let imageData = image.pngData() else { return }
        viewModel.action.onNext(.didTapDoneButton(imageData: imageData))
    }
    /// 크롭 이미지 뷰 취소 버튼 호출 시
    public func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: onDismiss)
    }
}
