//
//  AlertViewController.swift
//  BestWish
//
//  Created by 이수현 on 6/12/25.
//

import UIKit
import RxSwift
import RxCocoa

final class AlertViewController: UIViewController {
    private let type: AlertView.AlertType
    private let alertView: AlertView
    private let disposeBag = DisposeBag()

    init(type: AlertView.AlertType) {
        self.type = type
        alertView = AlertView(type: type)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = alertView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindView()
    }

    private func bindView() {
        alertView.dismiss
            .bind(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }.disposed(by: disposeBag)
    }
}
