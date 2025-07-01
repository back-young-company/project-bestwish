//
//  AlertLinkBuilder.swift
//  BestWish
//
//  Created by 백래훈 on 6/14/25.
//

import UIKit

final class AlertLinkBuilder {
    private let baseViewController: UIViewController
//    private let alertViewController: LinkSaveViewController

//    var getAlertViewController: LinkSaveViewController { return alertViewController }
    
    init(
        baseViewController: UIViewController,
        action: (() -> Void)? = nil
    ) {
        self.baseViewController = baseViewController
//        self.alertViewController = DIContainer.shared.makeLinkSaveViewController()
    }

    func show() {
//        alertViewController.modalPresentationStyle = .overFullScreen
//        alertViewController.modalTransitionStyle = .crossDissolve
//        alertViewController.delegate = baseViewController as? HomeViewControllerUpdate
//        baseViewController.present(alertViewController, animated: true)
    }
}
