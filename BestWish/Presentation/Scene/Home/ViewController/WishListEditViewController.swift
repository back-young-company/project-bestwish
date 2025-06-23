//
//  WishListEditViewController.swift
//  BestWish
//
//  Created by 백래훈 on 6/12/25.
//

import UIKit

import RxDataSources
import RxSwift
import RxRelay

final class WishListEditViewController: UIViewController {

    private let wishEditView = WishListEditView()
    private let wishEditViewModel: WishEditViewModel
    
    weak var delegate: HomeViewControllerUpdate?
    
    private let disposeBag = DisposeBag()
    
    init(wishEditViewModel: WishEditViewModel) {
        self.wishEditViewModel = wishEditViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = wishEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        bindViewModel()
        bindActions()
    }
    
    private func bindViewModel() {
        let dataSource = RxCollectionViewSectionedReloadDataSource<WishlistEditSectionModel>(
            configureCell: { dataSource, collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: WishListCell.identifier,
                    for: indexPath
                ) as? WishListCell else { return UICollectionViewCell() }
                cell.configure(type: item, isHidden: false)
                
                cell.getEditButton.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.wishEditViewModel.action.onNext(.delete(item.uuid, indexPath.item))
                    }
                    .disposed(by: cell.disposeBag)
                
                return cell
            }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: WishListEditHeaderView.identifier,
                    for: indexPath
                ) as? WishListEditHeaderView else { return UICollectionReusableView() }
                let totalItemCount = dataSource.sectionModels.flatMap { $0.items }.count
                headerView.configure(count: totalItemCount)
                
                headerView.getCompleteButton.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.wishEditViewModel.action.onNext(.complete)
                    }
                    .disposed(by: headerView.disposeBag)
                
                return headerView
            })
        
        wishEditViewModel.state.sections
            .bind(to: wishEditView.getCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        wishEditViewModel.state.sections
            .take(1)
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, sections in
                owner.setCollectionViewLayout(sections)
            }
            .disposed(by: disposeBag)
        
        wishEditViewModel.state.completed
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, _ in
                owner.delegate?.updateWishlists()
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindActions() {
        wishEditViewModel.action.onNext(.viewDidLoad)
        
        wishEditView.getBackButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func setNavigationBar() {
        self.title = "편집"
        self.navigationController?.navigationBar.isHidden = false
        
        let backItem = UIBarButtonItem(customView: wishEditView.getBackButton)
        self.navigationItem.leftBarButtonItem = backItem
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [
            .font: UIFont.font(.pretendardBold, ofSize: 18),
            .foregroundColor: UIColor.black
        ]
        appearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
}

private extension WishListEditViewController {
    func setCollectionViewLayout(_ sections: [WishlistEditSectionModel]) {
        wishEditView.getCollectionView.collectionViewLayout = UICollectionViewCompositionalLayout { sectionIndex, env -> NSCollectionLayoutSection? in
            return NSCollectionLayoutSection.createWishlistSection()
        }
    }
}
