//
//  CGFloat+Extension.swift
//  BestWish
//
//  Created by yimkeul on 6/9/25.
//

import UIKit

/// 기기별 화면 대응 코드
/// iphone 13 mini를 기준 (w: 375, h: 812)으로 리사이징
/// 사용법
/// 디자인 너비, 높이 크기 확인
/// SnapKit.make.width.equalT(oCGFloat(너비).fitWidth) , SnapKit.make.height.equalTo(CGFloat(높이).fitHeight)
extension CGFloat {
    static var isSESize: Bool {
        UIScreen.main.bounds.height < 812
    }

    var fitWidth: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.width / 375
        let scaled = self * ratio
        return self > scaled ? self : scaled
    }

    var fitHeight: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.height / 812
        let scaled = self * ratio
        return self > scaled ? self : scaled
    }
}
