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

/// 홈 View Controller
final class HomeViewController: UIViewController {

    // MARK: - Private Property
    private let homeViewModel: HomeViewModel
    private let homeView = HomeView()
    private let disposeBag = DisposeBag()

    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<HomeSectionModel>(
        configureCell: { [weak self] dataSource, collectionView, indexPath, item in
            guard let self else { return UICollectionViewCell() }

            switch item {
            case let .platform(platform):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PlatformShortcutCell.identifier,
                    for: indexPath
                ) as? PlatformShortcutCell else { return UICollectionViewCell() }

                cell.configure(type: platform)

                return cell
            case let .wishlist(product):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: WishListCell.identifier,
                    for: indexPath
                ) as? WishListCell else { return UICollectionViewCell() }

                let itemCount = collectionView.numberOfItems(inSection: indexPath.section)
                let isLastRow = {
                    let itemsPerRow = 2
                    let rowCount = Int(ceil(Double(itemCount) / Double(itemsPerRow)))
                    let currentRow = indexPath.item / itemsPerRow
                    return currentRow == rowCount - 1
                }()

                cell.configure(type: product, isHidden: true, isLastRow: isLastRow)

                return cell
            case .wishlistEmpty:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: WishListEmptyCell.identifier,
                    for: indexPath
                ) as? WishListEmptyCell else { return UICollectionViewCell() }

                cell.linkButton.rx.tap
                    .bind(with: self) { owner, _ in
                        AlertLinkBuilder(baseViewController: owner).show()
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
                headerView.editButton.rx.tap
                    .bind(with: self) { owner, _ in
                        let vc = DIContainer.shared.makePlatformEditViewController()
                        vc.delegate = owner
                        owner.navigationController?.pushViewController(vc, animated: true)
                    }.disposed(by: headerView.disposeBag)

                return headerView
            case .wishlist:
                if items.count == 1 && section.items.first == .wishlistEmpty {
                    guard let headerView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: WishListEmptyHeaderView.identifier,
                        for: indexPath
                    ) as? WishListEmptyHeaderView else { return UICollectionReusableView() }

                    return headerView
                } else {
                    guard let headerView = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: WishListHeaderView.identifier,
                        for: indexPath
                    ) as? WishListHeaderView else { return UICollectionReusableView() }
                    let totalItemCount = dataSource.sectionModels[1].items.map { $0 }.count

                    self.homeViewModel.state.selectedPlatform
                        .bind(to: headerView.selectedPlatformRelay)
                        .disposed(by: headerView.disposeBag)

                    headerView.configure(title: "쇼핑몰 위시리스트")
                    headerView.configure(productCount: totalItemCount)
                    headerView.configure(platforms: self.homeViewModel.state.platformFilter)

                    headerView.searchTextField.rx.text.orEmpty
                        .bind(with: self) { owner, query in
                            owner.homeViewModel.action.onNext(.searchQuery(query))
                        }.disposed(by: headerView.disposeBag)

                    headerView.searchTextField.rx.controlEvent(.editingDidEndOnExit)
                        .withLatestFrom(self.homeViewModel.state.selectedPlatform) { _, index in
                            return index
                        }
                        .bind(with: self) { owner, index in
                            headerView.searchTextField.resignFirstResponder()
                            owner.homeViewModel.action.onNext(.filterIndex(index, force: true))
                        }
                        .disposed(by: headerView.disposeBag)

                    headerView.selectedPlatformRelay
                        .bind(with: self) { owner, index in
                            owner.homeViewModel.action.onNext(.filterIndex(index))
                        }
                        .disposed(by: headerView.disposeBag)

                    headerView.linkButton.rx.tap
                        .bind(with: self) { owner, _ in
                            let alertViewController = DIContainer.shared.makeLinkSaveViewController()
                            alertViewController.modalPresentationStyle = .overFullScreen
                            alertViewController.modalTransitionStyle = .crossDissolve
                            alertViewController.delegate = owner

                            owner.present(alertViewController, animated: true)
                        }.disposed(by: headerView.disposeBag)

                    headerView.editButton.rx.tap
                        .bind(with: self) { owner, _ in
                            let vc = DIContainer.shared.makeWishlistEditViewController()
                            vc.delegate = owner
                            owner.navigationController?.pushViewController(vc, animated: true)
                        }.disposed(by: headerView.disposeBag)

                    return headerView
                }
            }
        })

    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar(alignment: .center, title: "")

        setNotification()
        bindViewModel()
        
        homeViewModel.action.onNext(.getDataSource)
    }

    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)

        self.navigationController?.navigationBar.isHidden = true
        showTabBar()

    }

    private func bindViewModel() {
        homeView.collectionView.rx.itemSelected
            .withLatestFrom(homeViewModel.state.sections) { indexPath, sections in
                return (indexPath, sections)
            }
            .compactMap { indexPath, sections -> HomeItem? in
                guard indexPath.section < sections.count else { return nil }
                let item = sections[indexPath.section].items[indexPath.item]
                return item
            }
            .bind(with: self) { owner, item in
                switch item {
                case let .platform(platform):
                    return owner.switchDeeplink(platform.platformDeepLink)
                case let .wishlist(product):
                    return owner.switchDeeplink(product.productDeepLink ?? "")
                case .wishlistEmpty:
                    return
                }
            }
            .disposed(by: disposeBag)
        
        homeViewModel.state.sections
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, sections in
                owner.setCollectionViewLayout(sections)
            }
            .disposed(by: disposeBag)
        
        homeViewModel.state.sections
            .bind(to: homeView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

// MARK: - private 메서드
private extension HomeViewController {
    /// 컬렉션 뷰 레이아웃 설정
    func setCollectionViewLayout(_ sections: [HomeSectionModel]) {
        homeView.collectionView.collectionViewLayout = UICollectionViewCompositionalLayout { sectionIndex, env -> NSCollectionLayoutSection? in
            guard sectionIndex < sections.count else { return nil }
            let section = sections[sectionIndex]
            
            switch section.header {
            case .platform:
                return NSCollectionLayoutSection.createPlatformShortcutSection()
            case .wishlist:
                let isEmptyState = section.items.count == 1 && section.items.first == .wishlistEmpty
                return isEmptyState ? NSCollectionLayoutSection.createWishlistEmptySection() : NSCollectionLayoutSection.createWishlistSection()
            }
        }
    }

    /// 외부 플랫폼 전환
    func switchDeeplink(_ link: String) {
        guard let url = URL(string: link) else {
            NSLog("url 생성 실패")
            return
        }

        UIApplication.shared.open(url) { success in
            if success {
                NSLog("✅ 앱 전환 성공: \(url.absoluteString)")
            } else {
                NSLog("❌ 앱 전환 실패: \(url.absoluteString)")
                self.showBasicAlert(title: "미지원 플랫폼", message: "해당 플랫폼은 추후 업데이트될 예정입니다.\n감사합니다.")
            }
        }
    }
}

// MARK: - Protocol 구현부
extension HomeViewController: HomeViewControllerUpdate {
    /// 플랫폼 업데이트
    func updatePlatforms() {
        self.homeViewModel.action.onNext(.platformUpdate)
    }

    /// 위시리스트 업데이트
    func updateWishlists() {
        self.homeViewModel.action.onNext(.wishlistUpdate)
    }
}

// MARK: - Notification 설정
private extension HomeViewController {
    /// 노티피케이션 등록
    func setNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(sceneWillEnterForground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }

    /// App Group UserDefaults 값 및 이벤트 전달
    @objc private func sceneWillEnterForground() {
        let sharedDefaults = UserDefaults(suiteName: "group.com.bycompany.bestwish")
        if let bool = sharedDefaults?.bool(forKey: "AddProduct"), bool {
            homeViewModel.action.onNext(.getDataSource)
            sharedDefaults?.set(false, forKey: "AddProduct")
        }
    }
}
