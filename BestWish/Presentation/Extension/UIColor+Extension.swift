//
//  UIColor+Extension.swift
//  BestWish
//
//  Created by 이수현 on 6/3/25.
//

import UIKit

// MARK: - UIColor Extension
extension UIColor {
    /// Hex 문자열을 UIColor로 변환하는 메서드
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        // Hex 문자열 길이에 따라 RGB 값을 추출
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        // UIColor 초기화
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

extension UIColor {
    static let primary900 = UIColor(hex: "#050212")
    static let primary800 = UIColor(hex: "#120740")
    static let primary700 = UIColor(hex: "#1E0C6E")
    static let primary600 = UIColor(hex: "#2B129C")
    static let primary500 = UIColor(hex: "#3717CA")
    static let primary400 = UIColor(hex: "#4E2CE7")
    static let primary300 = UIColor(hex: "#755AEC")
    static let primary200 = UIColor(hex: "#9986F1")
    static let primary100 = UIColor(hex: "#C2B6F7")
    static let primary50 = UIColor(hex: "#E8E3FC")

    static let secondary900 = UIColor(hex: "#1A1300")
    static let secondary800 = UIColor(hex: "#4D3800")
    static let secondary700 = UIColor(hex: "#805D00")
    static let secondary600 = UIColor(hex: "#B28300")
    static let secondary500 = UIColor(hex: "#E5A800")
    static let secondary400 = UIColor(hex: "#FFC21A")
    static let secondary300 = UIColor(hex: "#FFCF4D")
    static let secondary200 = UIColor(hex: "#FFDE82")
    static let secondary100 = UIColor(hex: "#FFEBB2")
    static let secondary50 = UIColor(hex: "#FFF8E5")

    static let gray900 = UIColor(hex: "#030303")
    static let gray800 = UIColor(hex: "#1D1D1D")
    static let gray700 = UIColor(hex: "#363636")
    static let gray600 = UIColor(hex: "#4F4F4F")
    static let gray500 = UIColor(hex: "#696969")
    static let gray400 = UIColor(hex: "#828282")
    static let gray300 = UIColor(hex: "#9C9C9C")
    static let gray200 = UIColor(hex: "#B5B5B5")
    static let gray100 = UIColor(hex: "#CFCFCF")
    static let gray50 = UIColor(hex: "#E8E8E8")
    static let gray0 = UIColor(hex: "#FFFFFF") // == white

    static let red0 = UIColor(hex: "FF2C2C") // cautionReed
}
