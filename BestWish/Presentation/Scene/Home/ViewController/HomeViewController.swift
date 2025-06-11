//
//  HomeViewController.swift
//  BestWish
//
//  Created by 백래훈 on 6/10/25.
//

import UIKit

import RxDataSources
import RxSwift
import RxRelay

final class HomeViewController: UIViewController {
    
    private let homeView = HomeView()
    private let homeViewModel = HomeViewModel()
    
    private let sections = BehaviorRelay<[HomeSectionModel]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        
    }
    
    private func bindViewModel() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<HomeSectionModel>(
            configureCell: { dataSource, collectionView, indexPath, item in
                switch item {
                case .platform(let platform):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: PlatformCell.identifier,
                        for: indexPath
                    ) as? PlatformCell else { return UICollectionViewCell() }
                    cell.configure(type: platform)
                    
                    return cell
                case .wishlist(let product):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: WishlistCell.identifier,
                        for: indexPath
                    ) as? WishlistCell else { return UICollectionViewCell() }
                    cell.configure(type: product)
                    
                    return cell
                }
            }
        )
        
        homeViewModel.state.sections
            .do(onNext: { [weak self] sections in
                guard let self else { return }
                self.sections.accept(sections)
                self.setCollectionViewLayout()
            })
            .bind(to: sections)
            .disposed(by: disposeBag)
        
        homeViewModel.state.sections
            .bind(to: homeView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
}

private extension HomeViewController {
    func setCollectionViewLayout() {
        homeView.collectionView.collectionViewLayout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, env -> NSCollectionLayoutSection? in
            guard let self else { return nil }
            
            let sections = self.sections.value
            guard sectionIndex < sections.count else { return nil }
            
            let section = sections[sectionIndex]
            
            switch section.header {
            case .platform:
                return self.createPlatformShortcutSection()
            case .wishlist:
                return self.createWishlistSection()
            }
        }
    }
    
    func createPlatformShortcutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(80),
            heightDimension: .absolute(102)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(500),
            heightDimension: .absolute(102)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 8)
        group.interItemSpacing = .fixed(2)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
        
        return section
    }

    func createWishlistSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .estimated(250)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 12, trailing: 6)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(250)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 14, bottom: 6, trailing: 14)
        section.interGroupSpacing = 12
        
        return section
    }
}
