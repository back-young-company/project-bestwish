//
//  ProfileSheetCell.swift
//  BestWish
//
//  Created by 이수현 on 6/10/25.
//

import UIKit

import SnapKit
import Then

final class ProfileSheetCell: UICollectionViewCell, ReuseIdentifier {
    private let _imageView = UIImageView()

    override var isSelected: Bool {
        didSet {
            _imageView.layer.borderWidth = isSelected ? 3 : 0
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setView()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError()
    }

    func configure(imageName: String) {
        _imageView.image = .init(named: imageName)
    }
}

private extension ProfileSheetCell {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        _imageView.do {
            $0.contentMode = .scaleAspectFit
            $0.layer.cornerRadius = CGFloat(80).fitHeight / 2
            $0.clipsToBounds = true
            $0.layer.borderColor = UIColor.primary300?.cgColor
        }
    }

    func setHierarchy() {
        self.contentView.addSubview(_imageView)
    }

    func setConstraints() {
        _imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
