//
//  LinkSaveViewController.swift
//  BestWish
//
//  Created by 백래훈 on 6/14/25.
//

import UIKit

import RxSwift
import RxCocoa

final class LinkSaveViewController: UIViewController {
    
    private let linkSaveView = LinkSaveView()
    private let viewModel: LinkSaveViewModel
    
    weak var delegate: HomeViewControllerUpdate?
    
    private let disposeBag = DisposeBag()

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
                print("저장 완료!!")
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
                owner.checkProductUrl(url)
            }.disposed(by: disposeBag)
    }
    
    private func checkProductUrl(_ url: String) {
        ShareExtensionService.shared
            .fetchPlatformMetadata(from: url)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(with: self, onSuccess: { owner, result in
                let (_, metaData) = result
                owner.viewModel.action.onNext(.product(metaData))
            }, onFailure: { owner, error in
                owner.showBasicAlert(title: "미지원 플랫폼", message: "해당 링크는 지원되지 않는 플랫폼 입니다.")
            })
            .disposed(by: disposeBag)
    }
}
