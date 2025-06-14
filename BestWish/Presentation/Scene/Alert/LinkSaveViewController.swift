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
    private let linkSaveView: LinkSaveView
    private let disposeBag = DisposeBag()
    private var confirmAction: (() -> Void)?

    init(action: (() -> Void)? = nil) {
        linkSaveView = LinkSaveView()
        confirmAction = action
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

        bindView()
    }

    private func bindView() {
        linkSaveView.dismiss
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }.disposed(by: disposeBag)

        linkSaveView.getSaveButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.confirmAction?()
                owner.dismiss(animated: true)
            }.disposed(by: disposeBag)
    }
}
