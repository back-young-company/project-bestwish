//
//  VerticalStackView.swift
//  BestWish
//
//  Created by 이수현 on 6/10/25.
//

import UIKit

/// 수직 라벨
final class VerticalStackView: UIStackView {
    init(spacing: CGFloat = 0) {
        super.init(frame: .zero)

        self.axis = .vertical
        self.spacing = spacing
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
