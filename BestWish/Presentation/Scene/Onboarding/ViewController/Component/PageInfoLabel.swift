//
//  PageInfoLabel.swift
//  BestWish
//
//  Created by yimkeul on 6/11/25.
//

import UIKit

final class PageInfoView: UILabel {

    init(current: Int, total: Int) {
        super.init(frame: .zero)
        setAttributes(current: current, total: total)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setAttributes(current: Int, total: Int) {
        // 1. 각 파트별로 속성 문자열 생성
        let currentAttr = NSAttributedString(
            string: "\(current)",
            attributes: [
                    .foregroundColor: UIColor.gray700!,
                    .font: UIFont.font(.pretendardBold, ofSize: 16)
            ]
        )
        let slashAttr = NSAttributedString(
            string: "/",
            attributes: [
                    .foregroundColor: UIColor.gray200!,
                    .font: UIFont.font(.pretendardBold, ofSize: 16)
            ]
        )
        let totalAttr = NSAttributedString(
            string: "\(total)",
            attributes: [
                    .foregroundColor: UIColor.gray200!,
                    .font: UIFont.font(.pretendardBold, ofSize: 16)
            ]
        )

        // 2. 합치기
        let combined = NSMutableAttributedString()
        combined.append(currentAttr)
        combined.append(slashAttr)
        combined.append(totalAttr)

        // 3. 레이블에 적용
        self.do {
            $0.attributedText = combined
            $0.textAlignment = .center
        }
    }
}
