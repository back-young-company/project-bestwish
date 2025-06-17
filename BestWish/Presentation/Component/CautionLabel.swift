//
//  CautionLabel.swift
//  BestWish
//
//  Created by 이수현 on 6/17/25.
//

import UIKit

final class CautionLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setAttributes() {
        text = OnboardingText.secondCaution.value
        font = .font(.pretendardMedium, ofSize: 12)
        textColor = .gray200
    }
}
