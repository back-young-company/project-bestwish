//
//  RadioButton.swift
//  BestWish
//
//  Created by yimkeul on 6/11/25.
//

import UIKit

class RadioButton: UIButton {
    private let offImage: UIImage?
    private let onImage: UIImage?

    init(
        title: String,
        offImage: UIImage? = UIImage(named: "radioOff"),
        onImage: UIImage? = UIImage(named: "radioOn"),
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

        let font: UIFont = .font(.pretendardMedium, ofSize: 18)
        // plain configuration
        var config = UIButton.Configuration.plain()
        config.title = title
        config.baseForegroundColor = .gray900
        config.baseBackgroundColor = .clear
        config.image = offImage
        config.imagePadding = 8
        config.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)

        config.titleTextAttributesTransformer =
            UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = font
            return outgoing
        }

        self.configuration = config

        self.configurationUpdateHandler = { [weak self] button in
            guard let self = self,
                var updated = button.configuration
                else { return }
            updated.image = button.isSelected ? self.onImage : self.offImage
            updated.background = .clear()
            button.configuration = updated
        }
    }
}
