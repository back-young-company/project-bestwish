//
//  LinkSaveViewController.swift
//  BestWish
//
//  Created by 백래훈 on 6/14/25.
//

import UIKit

import RxSwift
import RxCocoa

/// 링크 저장 View Controller
final class LinkSaveViewController: UIViewController {

    // MARK: - Private Property
    private let viewModel: LinkSaveViewModel
    private let linkSaveView = LinkSaveView()
    private let disposeBag = DisposeBag()

    weak var delegate: HomeViewControllerUpdate?

    init(viewModel: LinkSaveViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = linkSaveView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        bindActions()
    }
    
    private func bindViewModel() {
        viewModel.state.completed
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, _ in
                NSLog("저장 완료!!")
                owner.delegate?.updateWishlists()
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }

    private func bindActions() {
        linkSaveView.dismiss
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }.disposed(by: disposeBag)

        linkSaveView.getSaveButton.rx.tap
            .withLatestFrom(linkSaveView.getLinkInputTextField.rx.text.orEmpty) { _, url in
                return url
            }
            .bind(with: self) { owner, url in
                owner.viewModel.action.onNext(.addProduct(url))
            }.disposed(by: disposeBag)
    }
}
