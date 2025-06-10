//
//  HomeView.swift
//  BestWish
//
//  Created by 백래훈 on 6/10/25.
//

import UIKit

import SnapKit

final class HomeView: UIView {
    
    let collectionView = UICollectionView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
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
                MyPageHeaderView.self,
                forCellWithReuseIdentifier: MyPageHeaderView.identifier
            )
            $0.register(
                MyPageCell.self,
                forCellWithReuseIdentifier: MyPageCell.identifier
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
