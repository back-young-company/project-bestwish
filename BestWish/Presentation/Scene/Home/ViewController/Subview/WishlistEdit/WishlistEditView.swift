//
//  WishlistEditView.swift
//  BestWish
//
//  Created by 백래훈 on 6/12/25.
//

import UIKit

import SnapKit
import Then

final class WishlistEditView: UIView {
    
    private let backButton = UIButton()
    private let headerView = PlatformEditHeaderView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    var getBackButton: UIButton { backButton }
    var getHeaderView: PlatformEditHeaderView { headerView }
    var getCollectionView: UICollectionView { collectionView }
}

private extension WishlistEditView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        self.backgroundColor = .white
        
        collectionView.do {
            $0.register(
                WishlistCell.self,
                forCellWithReuseIdentifier: WishlistCell.identifier)
            $0.register(
                WishlistEditHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: WishlistEditHeaderView.identifier
            )
        }
        
        backButton.do {
            var config = UIButton.Configuration.plain()
            config.image = UIImage(systemName: "chevron.left")
            config.contentInsets = .init(top: 2, leading: 6, bottom: 2, trailing: 6)
            $0.configuration = config
            $0.tintColor = .black
        }
    }

    func setHierarchy() {
        self.addSubview(collectionView)
    }

    func setConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
