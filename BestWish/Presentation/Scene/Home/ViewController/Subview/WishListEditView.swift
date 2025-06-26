//
//  WishListEditView.swift
//  BestWish
//
//  Created by 백래훈 on 6/12/25.
//

import UIKit

import SnapKit
import Then

/// 위시리스트 편집 View
final class WishListEditView: UIView {

    // MARK: - Private Property
    private let _headerView = PlatformEditHeaderView()
    private let _collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )

    // MARK: - Internal Property
    var headerView: PlatformEditHeaderView { _headerView }
    var collectionView: UICollectionView { _collectionView }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - WishListEditView 설정
private extension WishListEditView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        self.backgroundColor = .white
        
        _collectionView.do {
            $0.register(
                WishListCell.self,
                forCellWithReuseIdentifier: WishListCell.identifier)
            $0.register(
                WishListEditHeaderView.self,
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: WishListEditHeaderView.identifier
            )
        }
    }

    func setHierarchy() {
        self.addSubview(_collectionView)
    }

    func setConstraints() {
        _collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
