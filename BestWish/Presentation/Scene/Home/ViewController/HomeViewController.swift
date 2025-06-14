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
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func bindViewModel() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<HomeSectionModel>(
            configureCell: { [weak self] dataSource, collectionView, indexPath, item in
                guard let self else { return UICollectionViewCell() }
                
                switch item {
                case .platform(let platform):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: PlatformShortcutCell.identifier,
                        for: indexPath
                    ) as? PlatformShortcutCell else { return UICollectionViewCell() }
                    cell.configure(type: platform)
                    
                    return cell
                case .wishlist(let product):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: WishlistCell.identifier,
                        for: indexPath
                    ) as? WishlistCell else { return UICollectionViewCell() }
                    
                    let itemCount = collectionView.numberOfItems(inSection: indexPath.section)
                        let isLastRow = {
                            let itemsPerRow = 2 // 레이아웃 기준
                            let rowCount = Int(ceil(Double(itemCount) / Double(itemsPerRow)))
                            let currentRow = indexPath.item / itemsPerRow
                            return currentRow == rowCount - 1
                        }()

                        cell.configure(type: product, isHidden: true, isLastRow: isLastRow)
                    
                    return cell
                case .wishlistEmpty:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: WishlistEmptyCell.identifier,
                        for: indexPath
                    ) as? WishlistEmptyCell else { return UICollectionViewCell() }
                    
                    cell.getLinkButton.rx.tap
                        .bind(with: self) { owner, _ in
                            AlertLinkBuilder(baseViewController: owner) {
                                print("로그아웃")
                            }.show()
                        }
                        .disposed(by: disposeBag)
                    
                    return cell
                }
            }, configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
                guard let self else { return UICollectionReusableView() }
                
                let section = dataSource.sectionModels[indexPath.section]
                let items = dataSource.sectionModels[indexPath.section].items
                
                switch section.header {
                case .platform:
                    guard let headerView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: PlatformShortcutHeaderView.identifier,
                        for: indexPath
                    ) as? PlatformShortcutHeaderView else { return UICollectionReusableView() }
                    
                    headerView.configure(title: "플랫폼 바로가기")
                    headerView.getEditButton().rx.tap
                        .bind(with: self) { owner, _ in
                            let vc = PlatformEditViewController()
                            owner.navigationController?.pushViewController(vc, animated: true)
                        }.disposed(by: headerView.disposeBag)
                    
                    return headerView
                case .wishlist:
                    if items.count == 1 && section.items.first == .wishlistEmpty {
                        guard let headerView = collectionView.dequeueReusableSupplementaryView(
                            ofKind: kind,
                            withReuseIdentifier: WishlistEmptyHeaderView.identifier,
                            for: indexPath
                        ) as? WishlistEmptyHeaderView else { return UICollectionReusableView() }
                        
                        return headerView
                    } else {
                        guard let headerView = collectionView.dequeueReusableSupplementaryView(
                            ofKind: kind,
                            withReuseIdentifier: WishlistHeaderView.identifier,
                            for: indexPath
                        ) as? WishlistHeaderView else { return UICollectionReusableView() }
                        let totalItemCount = dataSource.sectionModels[1].items.map { $0 }.count
                        headerView.configure(title: "쇼핑몰 위시리스트")
                        headerView.configure(productCount: totalItemCount)
                        headerView.configure(platforms: self.homeViewModel.state.platformFilter)
                        
                        headerView.getEditButton().rx.tap
                            .bind(with: self) { owner, _ in
                                let vc = WishlistEditViewController()
                                owner.navigationController?.pushViewController(vc, animated: true)
                            }.disposed(by: headerView.disposeBag)
                        
                        return headerView
                    }
                }
            })
        
        homeViewModel.state.sections
            .bind(with: self) { owner, sections in
                owner.setCollectionViewLayout(sections)
            }
            .disposed(by: disposeBag)
        
        homeViewModel.state.sections
            .bind(to: homeView.getCollectionView().rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

private extension HomeViewController {
    func setCollectionViewLayout(_ sections: [HomeSectionModel]) {
        homeView.getCollectionView().collectionViewLayout = UICollectionViewCompositionalLayout { sectionIndex, env -> NSCollectionLayoutSection? in
            guard sectionIndex < sections.count else { return nil }
            let section = sections[sectionIndex]
            
            switch section.header {
            case .platform:
                return NSCollectionLayoutSection.createPlatformShortcutSection()
            case .wishlist:
                let isEmptyState = section.items.count == 1 && section.items.first == .wishlistEmpty
                            return isEmptyState
                                ? NSCollectionLayoutSection.createWishlistEmptySection()
                                : NSCollectionLayoutSection.createWishlistSection()
            }
        }
    }
}
