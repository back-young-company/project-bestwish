//
//  HomeViewModel.swift
//  BestWish
//
//  Created by 백래훈 on 6/10/25.
//

import Foundation

import RxSwift
import RxRelay

final class HomeViewModel: ViewModel {
    
    enum Action {
        case getDataSource
        case platformUpdate
        case wishlistUpdate
        case filterIndex(Int, force: Bool = false)
        case searchQuery(String)
    }
    
    struct State {
        let sections: Observable<[HomeSectionModel]>
        let platformFilter: Observable<[(Int, Int)]>
        let platformSequence: Observable<[Int]>
        let selectedPlatform: Observable<Int>
        let error: Observable<Error>
    }
    
    private let _action = PublishSubject<Action>()
    
    private let _sections = BehaviorRelay<[HomeSectionModel]>(value: [])
    private let _platformFilter = BehaviorRelay<[(Int, Int)]>(value: [])
    private let _platformSequence = BehaviorRelay<[Int]>(value: [])
    private let _searchQuery = BehaviorRelay<String>(value: "")
    private let _selectedPlatform = BehaviorRelay<Int>(value: 0)
    private let _error = PublishRelay<Error>()
    
    private var previousIndex = 0
    
    private let useCase: WishListUseCase
    
    var action: AnyObserver<Action> { _action.asObserver() }
    let state: State
    
    private let disposeBag = DisposeBag()
    
    init(useCase: WishListUseCase) {
        self.useCase = useCase
        
        state = State(
            sections: _sections.asObservable(),
            platformFilter: _platformFilter.asObservable(),
            platformSequence: _platformSequence.asObservable(),
            selectedPlatform: _selectedPlatform.asObservable(),
            error: _error.asObservable()
        )
        
        self.bind()
    }
    
    private func bind() {
        _action
            .subscribe(with: self) { owner, action in
                switch action {
                case .getDataSource:
                    Task {
                        do {
                            // 플랫폼 필터 칩
                            let platformFilters = try await owner.getPlatformInWishList()
                            // 플랫폼 바로가기
                            let platforms = try await owner.getPlatformSequence()
                            // 위시리스트
                            let wishLists = try await owner.getWishLists()
                            
                            owner._platformFilter.accept(platformFilters)
                            owner._selectedPlatform.accept(0)
                            owner.setDataSources(platforms: platforms, wishLists: wishLists)
                        } catch {
                            owner._error.accept(error)
                        }
                    }
                case .platformUpdate:
                    Task {
                        do {
                            let platforms = try await owner.getPlatformSequence()
                            
                            let currentSections = owner._sections.value
                            guard currentSections.count == 2 else { return }
                            let wishlistsSection = currentSections[1]
                            
                            let platformsSection = HomeSectionModel(header: .platform, items: platforms.map { .platform($0) })
                            owner._sections.accept([platformsSection, wishlistsSection])
                        } catch {
                            owner._error.accept(error)
                        }
                    }
                case .wishlistUpdate:
                    Task {
                        do {
                            let platformFilters = try await owner.getPlatformInWishList()
                            let wishlists = try await owner.getWishLists()
                            let currentSections = owner._sections.value
                            guard currentSections.count == 2 else { return }
                            
                            let platformsSection = currentSections[0].items
                            
                            let platforms: [Platform] = platformsSection.compactMap {
                                if case let .platform(platform) = $0 {
                                    return platform
                                }
                                return nil
                            }
                            
//                            let wishlistsSection = HomeSectionModel(header: .wishlist, items: wishlists.map { .wishlist($0) })
                            
                            owner._platformFilter.accept(platformFilters)
                            owner.setDataSources(platforms: platforms, wishLists: wishlists)
                            
//                            owner._sections.accept([platformsSection, wishlistsSection])
                        } catch {
                            owner._error.accept(error)
                        }
                    }
                case .filterIndex(let index, let force):
                    Task {
                        do {
                            guard force || index != owner.previousIndex else { return }

                            let searchQuery = owner._searchQuery.value
                            let currentSections = owner._sections.value
                            guard currentSections.count == 2 else { return }

                            let platformSection = currentSections[0]
                            let wishlistProducts = try await owner.getWishLists(query: searchQuery, platform: index == 0 ? nil : index)
                            let wishlistsSection = HomeSectionModel(header: .wishlist, items: wishlistProducts.map { .wishlist($0) })

                            owner._selectedPlatform.accept(index)
                            owner._sections.accept([platformSection, wishlistsSection])
                            owner.previousIndex = index
                        } catch {
                            owner._error.accept(error)
                        }
                    }
                case .searchQuery(let query):
                    owner._searchQuery.accept(query)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func getPlatformSequence() async throws -> [Platform] {
        let result = try await self.useCase.getPlatformSequence()
        return result.map { platform in
            let shopPlatform = ShopPlatform.allCases[platform]
            return Platform(
                platformName: shopPlatform.platformName,
                platformImage: shopPlatform.rawValue,
                platformDeepLink: shopPlatform.platformDeepLink
            )
        }
    }
    
    private func getWishLists(query: String? = nil, platform: Int? = nil) async throws -> [WishlistProduct] {
        let result = try await self.useCase.searchWishListItems(query: query, platform: platform)
        return result.map { item in
            WishlistProduct(
                uuid: item.id,
                productImageURL: item.imagePathURL,
                brandName: item.brand,
                productName: item.title,
                productSaleRate: "\(item.discountRate)%",
                productPrice: "\(item.price.formattedPrice())원",
                productDeepLink: item.productURL ?? ""
            )
        }
    }
    
    private func getPlatformInWishList() async throws -> [(Int, Int)] {
        var result = try await self.useCase.getPlatformsInWishList(isEdit: false)
        result.insert((platform: 0, count: 0), at: 0)
        return result
    }
    
    private func setDataSources(platforms: [Platform], wishLists: [WishlistProduct]) {
        let platformsSection = HomeSectionModel(header: .platform, items: platforms.map { .platform($0) })
        
        let wishLists: [HomeItem] = wishLists.isEmpty ? [.wishlistEmpty] : wishLists.map { .wishlist($0) }
        let wishlistSection = HomeSectionModel(header: .wishlist, items: wishLists)

        _sections.accept([platformsSection, wishlistSection])
    }
}
