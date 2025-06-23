//
//  GroupTitleLabel.swift
//  BestWish
//
//  Created by 이수현 on 6/10/25.
//

import UIKit

final class GroupTitleLabel: UILabel {
    init(title: String) {
        super.init(frame: .zero)

        setAttributes(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setAttributes(title: String) {
        self.text = title
        self.textColor = .gray300
        self.font = .font(.pretendardBold, ofSize: 14)
    }
}
