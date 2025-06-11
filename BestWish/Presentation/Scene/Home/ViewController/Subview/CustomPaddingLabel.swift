//
//  CustomPaddingLabel.swift
//  BestWish
//
//  Created by 백래훈 on 6/11/25.
//

import UIKit

final class CustomPaddingLabel: UILabel {
    
    var contentInset: UIEdgeInsets = .zero

    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: contentInset)
        super.drawText(in: insetRect)
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let width = size.width + contentInset.left + contentInset.right
        let height = size.height + contentInset.top + contentInset.bottom
        return CGSize(width: width, height: height)
    }
}
