//
//  CGFloat+Extension.swift
//  BestWish
//
//  Created by yimkeul on 6/9/25.
//

import Foundation
import UIKit

/// 기기별 화면 대응 코드
/// iphone 13 mini를 기준 (w: 375, h: 812)으로 리사이징
/// 사용법
/// 디자인 너비, 높이 크기 확인
/// SnapKit.make.width.equalT(oCGFloat(너비).aW) , SnapKit.make.height.equalTo(CGFloat(높이).aH)
extension CGFloat {
    var aW: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.width / 375
        return self * ratio
    }

    var aH: CGFloat {
        let ratio: CGFloat = UIScreen.main.bounds.height / 812
        return self * ratio
    }
}
