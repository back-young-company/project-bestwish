//
//  ShareView.swift
//  BestWishShareExtension
//
//  Created by 백래훈 on 6/14/25.
//

import UIKit

import SnapKit
import Then

//import BestWish

final class ShareView: UIView {
    
    private let grabBar = UIView()
    private let completeImage = UIImageView()
    private let completeLabel = UILabel()
    private let shortcutButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

private extension ShareView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        grabBar.do {
            $0.backgroundColor = UIColor(hex: "CFCFCF")
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 3
        }
        
        completeImage.do {
            $0.image = UIImage(named: "complete")
        }
        
        completeLabel.do {
            $0.text = "저장 완료!"
            $0.font = .systemFont(ofSize: 18, weight: .bold)
            $0.textColor = .black
        }
        
        shortcutButton.do {
            var config = UIButton.Configuration.plain()
            config.imagePadding = 4
            config.imagePlacement = .trailing
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .regular)
            let titleFont = UIFont.systemFont(ofSize: 18, weight: .bold)
            
            config.image = UIImage(systemName: "chevron.right")?.withConfiguration(symbolConfig)
//            config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            config.attributedTitle = AttributedString("바로가기", attributes: AttributeContainer([.font: titleFont]))
            config.baseForegroundColor = .brown
//            config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 14, bottom: 6, trailing: 14)
            $0.configuration = config
        }
    }

    func setHierarchy() {
        self.addSubviews(grabBar, completeImage, completeLabel, shortcutButton)
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
        }
        
        shortcutButton.snp.makeConstraints {
            $0.centerY.equalTo(completeLabel)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
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
}
