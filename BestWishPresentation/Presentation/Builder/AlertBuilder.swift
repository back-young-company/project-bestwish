//
//  AlertBuilder.swift
//  BestWish
//
//  Created by 이수현 on 6/12/25.
//

import UIKit

/// Custum Alert View
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

    /// Custom Alert 띄우기
    func show() {
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.modalTransitionStyle = .crossDissolve
        baseViewController.present(alertViewController, animated: true)
    }
}
