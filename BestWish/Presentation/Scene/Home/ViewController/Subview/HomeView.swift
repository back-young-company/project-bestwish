//
//  HomeView.swift
//  BestWish
//
//  Created by 백래훈 on 6/10/25.
//

import UIKit

import SnapKit
import Then

/// 홈 View
final class HomeView: UIView {

    // MARK: - Private Property
    private let _collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )

    // MARK: - Internal Property
    var collectionView: UICollectionView { _collectionView }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - HomeView 설정
private extension HomeView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        self.backgroundColor = .white
        
        _collectionView.do {
            $0.register(
                PlatformShortcutCell.self,
                forCellWithReuseIdentifier: PlatformShortcutCell.identifier
            )
            $0.register(
                WishListCell.self,
                forCellWithReuseIdentifier: WishListCell.identifier
            )
            $0.register(
                WishListEmptyCell.self,
                forCellWithReuseIdentifier: WishListEmptyCell.identifier
            )
            $0.register(
                PlatformShortcutHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: PlatformShortcutHeaderView.identifier
            )
            $0.register(
                WishListHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: WishListHeaderView.identifier
            )
            $0.register(
                WishListEmptyHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: WishListEmptyHeaderView.identifier
            )
        }
    }

    func setHierarchy() {
        addSubviews(_collectionView)
    }

    func setConstraints() {
        _collectionView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.bottom.directionalHorizontalEdges.equalToSuperview()
        }
    }
}
