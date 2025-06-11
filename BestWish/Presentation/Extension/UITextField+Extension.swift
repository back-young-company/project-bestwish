//
//  UITextField+Extension.swift
//  BestWish
//
//  Created by 이수현 on 6/10/25.
//

import UIKit

extension UITextField {
    func addUnderLine(color: UIColor = .gray50 ?? .systemGray, height: CGFloat = 1.5) {
        let name = "underline"
        guard self.layer.sublayers?.first(where: { $0.name == name }) == nil else {
            return
        }

        let border = CALayer()
        border.name = name

        border.frame = CGRect(
            x: 0,
            y: self.frame.height - height,
            width: self.frame.width,
            height: height
        )
        border.borderColor = color.cgColor
        border.borderWidth = height
        self.layer.addSublayer(border)
    }
}
