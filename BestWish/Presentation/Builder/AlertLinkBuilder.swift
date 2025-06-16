//
//  AlertLinkBuilder.swift
//  BestWish
//
//  Created by 백래훈 on 6/14/25.
//

import UIKit

final class AlertLinkBuilder {
    private let baseViewController: UIViewController
    private let alertViewController: LinkSaveViewController

    init(
        baseViewController: UIViewController,
        action: (() -> Void)? = nil
    ) {
        self.baseViewController = baseViewController
        self.alertViewController = LinkSaveViewController(action: action)
    }

    func show() {
        alertViewController.modalPresentationStyle = .overFullScreen
        alertViewController.modalTransitionStyle = .crossDissolve
        baseViewController.present(alertViewController, animated: true)
    }
}
