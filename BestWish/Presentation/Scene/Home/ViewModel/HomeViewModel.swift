//
//  HomeViewModel.swift
//  BestWish
//
//  Created by 백래훈 on 6/10/25.
//

import Foundation

import RxSwift
import RxRelay

/// 홈 View Model
final class HomeViewModel: ViewModel {

    // MARK: - Action
    enum Action {
        case getDataSource
        case platformUpdate
        case wishListUpdate
        case filterIndex(Int)
        case searchQuery(String)
    }

    // MARK: - State
    struct State {
        let sections: Observable<[HomeSectionModel]>
        let selectedPlatform: Observable<Int>
        let error: Observable<Error>
    }

    // MARK: - Internal Property
    var action: AnyObserver<Action> { _action.asObserver() }
    let state: State

    // MARK: - Private Property
    private let _action = PublishSubject<Action>()

    private let _sections = BehaviorRelay<[HomeSectionModel]>(value: [])
    private let _searchQuery = BehaviorRelay<String>(value: "")
    private let _selectedPlatform = BehaviorRelay<Int>(value: 0)
    private let _error = PublishRelay<Error>()

    private let useCase: WishListUseCase
    private let disposeBag = DisposeBag()

    init(useCase: WishListUseCase) {
        self.useCase = useCase

        state = State(
            sections: _sections.asObservable(),
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
                    owner.setDataSources()
                case .platformUpdate:
                    owner.platformUpdate()
                case .wishListUpdate:
                    owner.wishListUpdate()
                case let .filterIndex(index):
                    owner.filterTapped(index)
                case let .searchQuery(query):
                    owner._searchQuery.accept(query)
                    owner.queryUpdate(query)
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - useCase 메서드 호출
private extension HomeViewModel {
    /// Supabase 플랫폼 시퀀스 가져오기
    func getPlatformSequence() async throws -> [PlatformEntity] {
        let result = try await self.useCase.getPlatformSequence()
        return result.compactMap { platform in
            guard platform <= 8 else { return nil }
            return PlatformEntity.allCases[platform]
        }
    }

    /// Supabase 위시리스트 가져오기
    func getWishLists(query: String? = nil, platform: Int? = nil) async throws -> [WishListProductItem] {
        let result = try await self.useCase.searchWishListItems(query: query, platform: platform)
        return result.map { item in
            WishListProductItem(
                uuid: item.id,
                productImageURL: item.imagePathURL,
                brandName: item.brand,
                productName: item.title,
                productSaleRate: (item.discountRate ?? "") + "%",
                productPrice: (item.price?.formattedPrice() ?? "") + "원",
                productDeepLink: item.productURL ?? "",
                platformImage: PlatformEntity(index: item.platform ?? 0)?.platformImage ?? "",
                platformName: PlatformEntity(index: item.platform ?? 0)?.platformName ?? ""
            )
        }
    }

    /// Supabase 위시리스트 필터 가져오기
    func getPlatformInWishList() async throws -> [(Int, Int)] {
        var result = try await self.useCase.getPlatformsInWishList(isEdit: false)
        if result.isEmpty {
            return result
        } else {
            result.insert((platform: 0, count: 0), at: 0)
        }
        return result
    }
}

// MARK: - Section Update 메서드
private extension HomeViewModel {
    /// section model 설정
    func setDataSources() {
        Task {
            do {
                let platforms = try await getPlatformSequence()
                let filters = try await getPlatformInWishList()
                let wishLists = try await getWishLists()

                let platformsSection = HomeSectionModel(header: .platform, items: platforms.map { .platform($0) })
                let filterSection = HomeSectionModel(header: .filter, items: filters.map { .filter($0.0, $0.0 == 0) })
                let wishlistSection = HomeSectionModel(header: .wishlist, items: wishLists.map { .wishlist($0) })

                _sections.accept([platformsSection, filterSection, wishlistSection])
            } catch {
                _error.accept(error)
            }
        }
    }

    /// 플랫폼 바로가기 업데이트
    func platformUpdate() {
        Task {
            do {
                let platforms = try await getPlatformSequence()

                var currentSections = _sections.value
                currentSections[0].items = platforms.map { .platform($0) }

                _sections.accept(currentSections)
            } catch {
                _error.accept(error)
            }
        }
    }

    /// 위시리스트 업데이트
    func wishListUpdate() {
        Task {
            do {
                let filters = try await getPlatformInWishList()
                let wishlists = try await getWishLists()

                var currentSections = _sections.value
                currentSections[1].items = filters.map { .filter($0.0, $0.0 == 0) }
                currentSections[2].items = wishlists.map { .wishlist($0) }

                _sections.accept(currentSections)
            } catch {
                _error.accept(error)
            }
        }
    }

    /// 필터 버튼 탭 (전체, 무신사, 지그재그 등)
    func filterTapped(_ index: Int) {
        Task {
            do {
                let searchQuery = _searchQuery.value
                var currentSections = _sections.value
                let wishlistProducts = try await getWishLists(query: searchQuery, platform: index == 0 ? nil : index)

                let oldFilters = currentSections[1].items
                let newFilters: [HomeItem] = oldFilters.map {
                    switch $0 {
                    case let .filter(filterIndex, _):
                        return .filter(filterIndex, filterIndex == index)
                    default:
                        return $0
                    }
                }

                currentSections[1].items = newFilters
                currentSections[2].items = wishlistProducts.map { .wishlist($0) }

                _selectedPlatform.accept(index)
                _sections.accept(currentSections)
            } catch {
                _error.accept(error)
            }
        }
    }

    /// 검색어가 변경될 때 위시리스트 업데이트
    func queryUpdate(_ query: String) {
        Task {
            do {
                let currentPlatformIndex: Int? = _selectedPlatform.value == 0 ? nil : _selectedPlatform.value
                let wishlistProducts = try await getWishLists(query: query, platform: currentPlatformIndex)

                var currentSections = _sections.value

                currentSections[2].items = wishlistProducts.map { .wishlist($0) }
                _sections.accept(currentSections)
            } catch {
                _error.accept(error)
            }
        }
    }
}
