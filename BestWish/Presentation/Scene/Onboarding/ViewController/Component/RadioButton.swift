//
//  RadioButton.swift
//  BestWish
//
//  Created by yimkeul on 6/11/25.
//

import UIKit
import Then

final class RadioButton: UIButton {

    init(title: String) {
        super.init(frame: .zero)
        setAttributes(title: title)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) 사용 불가")
    }

    private func setAttributes(title: String) {
        self.do {
            var config = UIButton.Configuration.plain()
            config.title = title
            config.baseForegroundColor = .gray900
            config.background.backgroundColor = .clear
            config.imagePadding = 8
            config.contentInsets = .zero

            config.titleTextAttributesTransformer =
                UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = .font(.pretendardMedium, ofSize: 18)
                return outgoing
            }
            $0.configuration = config

            $0.setImage(UIImage(named: "radioOff"), for: .normal)
            $0.setImage(UIImage(named: "radioOn"), for: .selected)
        }
    }
}
