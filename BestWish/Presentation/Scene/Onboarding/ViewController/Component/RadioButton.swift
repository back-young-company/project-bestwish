//
//  RadioButton.swift
//  BestWish
//
//  Created by yimkeul on 6/11/25.
//

import UIKit
import Then

// TODO: 버튼을 선택하고 데이트 피커를 띄었을때 회색 배경처리됨을 확인함. (수정필요)
final class RadioButton: UIButton {
    private let offImage: UIImage?
    private let onImage: UIImage?

    init(
        title: String,
        offImage: UIImage? = UIImage(named: "radioOff"),
        onImage: UIImage? = UIImage(named: "radioOn")
    ) {
        self.offImage = offImage
        self.onImage = onImage
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
            
            $0.setImage(offImage, for: .normal)
            $0.setImage(onImage, for: .selected)
        }
    }
}
