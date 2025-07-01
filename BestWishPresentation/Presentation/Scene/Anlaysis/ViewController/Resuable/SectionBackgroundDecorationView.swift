//
//  SectionBackgroundDecorationView.swift
//  BestWish
//
//  Created by Quarang on 6/23/25.
//

import UIKit

/// 섹션 백그라운드
final class SectionBackgroundDecorationView: UICollectionReusableView, ReuseIdentifier {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.secondarySystemBackground
        layer.cornerRadius = 8
        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
