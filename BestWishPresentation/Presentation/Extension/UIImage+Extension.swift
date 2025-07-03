//
//  UIImage+Extension.swift
//  BestWish
//
//  Created by yimkeul on 6/9/25.
//

import UIKit

extension UIImage {
    func resize(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: .zero, size: size))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result ?? self
    }

    /// PNG, SVG 등 투명 이미지에 배경색을 입힌 새로운 이미지 반환
    func withBackground(color: UIColor = .white) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = self.scale
        format.opaque = true // 투명 안쓰고 JPG처럼 렌더링

        let renderer = UIGraphicsImageRenderer(size: self.size, format: format)
        return renderer.image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: self.size))
            self.draw(at: .zero)
        }
    }
}
