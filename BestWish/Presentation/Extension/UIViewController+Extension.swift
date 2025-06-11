//
//  UIViewController+Extension.swift
//  BestWish
//
//  Created by 이수현 on 6/9/25.
//

import UIKit

extension UIViewController {
    enum Alignment {
        case left
        case center
    }

    func setNavigationBar(alignment: UIViewController.Alignment, title: String) {
        self.navigationController?.navigationBar.tintColor = .gray900
        self.navigationItem.backButtonTitle = ""

        switch alignment {
        case .left:
            let label = UILabel()
            label.text = title
            label.font = .font(.pretendardBold, ofSize: 18)
            let leftBarItem = UIBarButtonItem(customView: label)
            self.navigationItem.setLeftBarButton(leftBarItem, animated: true)
        case .center:
            self.title = title
        }
    }
}
