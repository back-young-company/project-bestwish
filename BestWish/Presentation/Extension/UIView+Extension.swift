//
//  UIView+Extension.swift
//  BestWish
//
//  Created by 이수현 on 6/3/25.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }
}
