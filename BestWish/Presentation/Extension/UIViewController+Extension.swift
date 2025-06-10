//
//  UIViewController+Extension.swift
//  BestWish
//
//  Created by 이수현 on 6/9/25.
//

import UIKit

extension UIViewController {

    func setLeftBarItem(with title: String) {
        let label = UILabel()
        label.text = title
        label.font = .font(.pretendardBold, ofSize: 18)
        label.textColor = .gray900
        let leftBarItem = UIBarButtonItem(customView: label)
        self.navigationItem.setLeftBarButton(leftBarItem, animated: true)
    }
}
