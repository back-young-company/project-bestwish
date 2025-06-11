//
//  HorizontalStackView.swift
//  BestWish
//
//  Created by yimkeul on 6/11/25.
//

import UIKit

final class HorizontalStackView: UIStackView {
    init(spacing: CGFloat = 0) {
        super.init(frame: .zero)

        self.axis = .horizontal
        self.spacing = spacing
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

