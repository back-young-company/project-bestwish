//
//  HomeView.swift
//  BestWish
//
//  Created by 백래훈 on 6/10/25.
//

import UIKit

import SnapKit

final class HomeView: UIView {
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    var getCollectionView: UICollectionView { collectionView }
}

private extension HomeView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        self.backgroundColor = .white
        
        collectionView.do {
            $0.register(
                PlatformShortcutCell.self,
                forCellWithReuseIdentifier: PlatformShortcutCell.identifier
            )
            $0.register(
                WishlistCell.self,
                forCellWithReuseIdentifier: WishlistCell.identifier
            )
            $0.register(
                WishlistEmptyCell.self,
                forCellWithReuseIdentifier: WishlistEmptyCell.identifier
            )
            $0.register(
                PlatformShortcutHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: PlatformShortcutHeaderView.identifier
            )
            $0.register(
                WishlistHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: WishlistHeaderView.identifier
            )
            $0.register(
                WishlistEmptyHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: WishlistEmptyHeaderView.identifier
            )
        }
    }

    func setHierarchy() {
        addSubviews(collectionView)
    }

    func setConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.bottom.directionalHorizontalEdges.equalToSuperview()
        }
    }
}
