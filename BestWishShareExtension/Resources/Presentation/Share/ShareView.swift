//
//  ShareView.swift
//  BestWishShareExtension
//
//  Created by 백래훈 on 6/14/25.
//

import UIKit

import SnapKit
import Then

final class ShareView: UIView {
    
    private let grabBar = UIView()
    private let completeImage = UIImageView()
    private let completeLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let shortcutButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    var getShortcutButton: UIButton { shortcutButton }
}

private extension ShareView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 15
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        grabBar.do {
            $0.backgroundColor = .gray100
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 3
        }
        
        completeImage.do {
            $0.image = UIImage(systemName: "paperplane.fill")
            $0.tintColor = .primary200
            $0.contentMode = .scaleAspectFit
        }
        
        completeLabel.do {
            $0.text = "저장 중..."
            $0.font = .font(.pretendardBold, ofSize: 18)
            $0.textColor = .black
        }
        
        descriptionLabel.do {
            $0.text = "저장이 완료되면 앱으로 다시 돌아가 주세요!"
            $0.font = .font(.pretendardBold, ofSize: 16)
            $0.textColor = .black
        }
        
        shortcutButton.do {
            var config = UIButton.Configuration.plain()
            config.imagePadding = 4
            config.imagePlacement = .trailing
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .semibold)
            let titleFont = UIFont.font(.pretendardBold, ofSize: 12)
            
            config.image = UIImage(systemName: "chevron.right")?.withConfiguration(symbolConfig)
            config.attributedTitle = AttributedString("바로가기", attributes: AttributeContainer([.font: titleFont]))
            config.baseForegroundColor = .primary200
            config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6)
            $0.configuration = config
        }
    }

    func setHierarchy() {
        self.addSubviews(grabBar, completeImage, completeLabel, descriptionLabel)
    }

    func setConstraints() {
        grabBar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(50)
            $0.height.equalTo(6)
        }
        
        completeImage.snp.makeConstraints {
            $0.top.equalTo(grabBar.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        completeLabel.snp.makeConstraints {
            $0.centerY.equalTo(completeImage)
            $0.leading.equalTo(completeImage.snp.trailing).offset(8)
            $0.height.equalTo(18)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(completeImage.snp.bottom).offset(12)
            $0.leading.equalTo(completeImage)
        }
        
//        shortcutButton.snp.makeConstraints {
//            $0.centerY.equalTo(completeLabel)
//            $0.trailing.equalToSuperview().offset(-20)
//        }
    }
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }
}

extension ShareView {
    func successConfigure() {
        completeImage.image = UIImage(named: "complete")
        completeLabel.text = "저장 완료!"
    }
    
    func failureConfigure() {
        completeImage.image = UIImage(systemName: "xmark.circle.fill")
        completeLabel.text = "저장 실패"
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static let primary200 = UIColor(hex: "#9986F1")
    
    static let gray100 = UIColor(hex: "#CFCFCF")
    static let gray900 = UIColor(hex: "#030303")
}

extension UIFont {
    enum FontName2: String, CaseIterable {
        case pretendardBold = "Pretendard-Bold"
    }

    static func font(_ style: FontName2, ofSize size: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: style.rawValue, size: size) else {
            print("\(style.rawValue) font가 등록되지 않았습니다.")
            return UIFont.systemFont(ofSize: size)
        }
        return customFont
    }
}
