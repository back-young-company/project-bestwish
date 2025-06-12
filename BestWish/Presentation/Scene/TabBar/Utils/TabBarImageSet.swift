//
//  TabBarImageSet.swift
//  BestWish
//
//  Created by Quarang on 6/11/25.
//

import UIKit

// MARK: - TabBarImageSet 구조체 외부로 분리
struct TabBarImageSet {
    struct ItemImages {
        let normal: UIImage?
        let highlight: UIImage?
    }

    let left: ItemImages
    let center: ItemImages
    let right: ItemImages

    init(mode: TabBarMode, floating: FloatingMode) {
        left = TabBarImageSet.imageSet(for: .left, mode: mode, floating: floating)
        center = TabBarImageSet.imageSet(for: .center, mode: mode, floating: floating)
        right = TabBarImageSet.imageSet(for: .right, mode: mode, floating: floating)
    }
    
    /// 버튼의 실제 위치, 선택된 탭, 플로팅 모드에 따라 이미지를 반환하는 메서드
    private static func imageSet(for position: TabBarMode, mode: TabBarMode, floating: FloatingMode) -> ItemImages {
        func image(_ name: String) -> UIImage? { UIImage(named: name) }

        switch (position, floating) {
        case (.left, .home):
            return ItemImages(normal: image(mode == .left ? "home_se1" : "home_de1"), highlight: nil)
        case (.left, .camera):
            return ItemImages(normal: image("camera_de1"), highlight: image("camera_se1"))
        case (.center, .home):
            return ItemImages(normal: image(mode == .center ? "home_se2" : "home_de2"), highlight: nil)
        case (.center, .camera):
            return ItemImages(normal: image("camera_de2"), highlight: image("camera_se2"))
        case (.right, .home):
            return ItemImages(normal: image(mode == .right ? "home_se3" : "home_de3"), highlight: nil)
        case (.right, .camera):
            return ItemImages(normal: image("camera_de3"), highlight: image("camera_se3"))
        }
    }
}
