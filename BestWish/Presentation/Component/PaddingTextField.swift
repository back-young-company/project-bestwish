//
//  PaddingTextField.swift
//  BestWish
//
//  Created by yimkeul on 6/12/25.
//

import UIKit

final class PaddingTextField: UITextField {
    private let padding: UIEdgeInsets

    // 원하는 여백을 init 파라미터로 받도록
    init(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        self.padding = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 텍스트가 표시되는 영역
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    // 편집 중인 텍스트 영역
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    // 플레이스홀더 영역
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
}
