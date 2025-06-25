//
//  AlertBuilder.swift
//  BestWish
//
//  Created by 이수현 on 6/12/25.
//

import UIKit

final class AlertBuilder {
    private let baseViewController: UIViewController
    private let alertViewController: AlertViewController

    init(
        baseViewController: UIViewController,
        type: AlertView.AlertType,
        action: (() -> Void)? = nil
    ) {
        self.baseViewController = baseViewController
        self.alertViewController = AlertViewController(type: type, action: action)
    }

    func show() {
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.modalTransitionStyle = .crossDissolve
        baseViewController.present(alertViewController, animated: true)
    }
}
