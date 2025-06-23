//
//  UIFont+Extension.swift
//  BestWish
//
//  Created by 이수현 on 6/3/25.
//

import UIKit

extension UIFont {
    /// 커스텀 폰트 이름 열거형
    enum FontName: String, CaseIterable {
        case antonRegular = "Anton-Regular"
        
        case pretendardBlack = "Pretendard-Black"
        case pretendardBold = "Pretendard-Bold"
        case pretendardExtraBold = "Pretendard-ExtraBold"
        case pretendardExtraLight = "Pretendard-ExtraLight"
        case pretendardLight = "Pretendard-Light"
        case pretendardMedium = "Pretendard-Medium"
        case pretendardRegular = "Pretendard-Regular"
        case pretendardSemiBold = "Pretendard-SemiBold"
        case pretendardThin = "Pretendard-Thin"
    }

    /// 커스텀 폰트 메서드
    static func font(_ style: FontName, ofSize size: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: style.rawValue, size: size) else {
            print("\(style.rawValue) font가 등록되지 않았습니다.")
            return UIFont.systemFont(ofSize: size)
        }

        return customFont
    }
}
