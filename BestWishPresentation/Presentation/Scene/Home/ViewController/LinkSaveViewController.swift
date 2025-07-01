//
//  LinkSaveViewController.swift
//  BestWish
//
//  Created by 백래훈 on 6/14/25.
//

import UIKit

internal import RxSwift
internal import RxCocoa

/// 상품 추가 View Controller
public final class LinkSaveViewController: UIViewController {

    // MARK: - Private Property
    private let viewModel: LinkSaveViewModel
    private let linkSaveView = LinkSaveView()
    private let disposeBag = DisposeBag()

    weak var delegate: HomeViewControllerUpdate?

    public init(viewModel: LinkSaveViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        view = linkSaveView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        bindActions()
    }
    
    private func bindViewModel() {
        // 상품 저장 완료 시
        viewModel.state.completed
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, _ in
                NSLog("저장 완료!!")
                owner.delegate?.updateWishlists()
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)

        // 상품 저장 실패 시
        viewModel.state.error
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, error in
                owner.showBasicAlert(title: "저장 실패", message: "상품 저장에 실패하였습니다.\n다시 시도해 주세요.")
            }
            .disposed(by: disposeBag)
    }

    private func bindActions() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.delegate = self
        linkSaveView.addGestureRecognizer(tapGesture)

        Observable.merge(
            tapGesture.rx.event.map { _ in },
            linkSaveView.cancelButton.rx.tap.map { }
        ).bind(with: self) { owner, _ in
            owner.dismiss(animated: true)
        }.disposed(by: disposeBag)

        linkSaveView.saveButton.rx.tap
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.asyncInstance)
            .withLatestFrom(linkSaveView.linkInputTextField.rx.text.orEmpty) { _, url in
                return url
            }
            .bind(with: self) { owner, url in
                owner.viewModel.action.onNext(.addProduct(url))
            }.disposed(by: disposeBag)
    }
}

extension LinkSaveViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchLocation = touch.location(in: linkSaveView)
        return !linkSaveView.linkView.frame.contains(touchLocation)
    }
}
