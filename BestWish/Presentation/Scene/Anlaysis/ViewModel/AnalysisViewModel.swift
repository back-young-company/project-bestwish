//
//  AnalysisViewModel.swift
//  BestWish
//
//  Created by Quarang on 6/12/25.
//

import RxSwift
import RxRelay

// MARK: - 이미지 분석 ViewModel
final class AnalysisViewModel: ViewModel {
    
    let analysisSectionModel: [AnalysisItem] =
        [
            .platform(platform: Platform(
                platform: .musinsa,
                platformName: ShopPlatform.musinsa.platformName,
                platformImage: PlatformImage.musinsa,
                platformDeepLink: ShopPlatform.musinsa.platformDeepLink
            )),
            .platform(platform: Platform(
                platform: .zigzag,
                platformName: ShopPlatform.zigzag.platformName,
                platformImage: PlatformImage.zigzag,
                platformDeepLink: ShopPlatform.zigzag.platformDeepLink
            )),
            .platform(platform: Platform(
                platform: .ably,
                platformName: ShopPlatform.ably.platformName,
                platformImage: PlatformImage.ably,
                platformDeepLink: ShopPlatform.ably.platformDeepLink
            )),
            .platform(platform: Platform(
                platform: .kream,
                platformName: ShopPlatform.kream.platformName,
                platformImage: PlatformImage.kream,
                platformDeepLink: ShopPlatform.kream.platformDeepLink
            )),
            .platform(platform: Platform(
                platform: .brandy,
                platformName: ShopPlatform.brandy.platformName,
                platformImage: PlatformImage.brandy,
                platformDeepLink: ShopPlatform.brandy.platformDeepLink
            )),
            .platform(platform: Platform(
                platform: .tncm,
                platformName: ShopPlatform.tncm.platformName,
                platformImage: PlatformImage.tncm,
                platformDeepLink: ShopPlatform.tncm.platformDeepLink
            )),
            .platform(platform: Platform(
                platform: .oco,
                platformName: ShopPlatform.oco.platformName,
                platformImage: PlatformImage.oco,
                platformDeepLink: ShopPlatform.oco.platformDeepLink
            )),
            .platform(platform: Platform(
                platform: .fnoz,
                platformName: ShopPlatform.fnoz.platformName,
                platformImage: PlatformImage.fnoz,
                platformDeepLink: ShopPlatform.fnoz.platformDeepLink
            )),
            .platform(platform: Platform(
                platform: .worksout,
                platformName: ShopPlatform.worksout.platformName,
                platformImage: PlatformImage.worksout,
                platformDeepLink: ShopPlatform.worksout.platformDeepLink
            )),
            .platform(platform: Platform(
                platform: .eql,
                platformName: ShopPlatform.eql.platformName,
                platformImage: PlatformImage.eql,
                platformDeepLink: ShopPlatform.eql.platformDeepLink
            )),
            .platform(platform: Platform(
                platform: .hiver,
                platformName: ShopPlatform.hiver.platformName,
                platformImage: PlatformImage.hiver,
                platformDeepLink: ShopPlatform.hiver.platformDeepLink
            ))
        ]
    
    private let dummyUseCase: DummyUseCase
    private let disposeBag = DisposeBag()
    
    enum Action {
        case didSelectedSegmentControl(category: String)    // 세그먼트 컨트롤 선택 시
        case didTapAttributeChip(attribute: String)         // 속성 칩 선택 시
        case didSubmitSearchText(keyword: String)           // 검색버튼 터치 시
        case didTapKeywordChip(keyword: String)             // 키워드 칩 선택 시
        case didTapPlatformChip(platform: Platform)         // 플랫폼 칩 선택 시
        case didTapResetButton                              // 초기화 버튼 선택 시
        case didTapSearchButton                             // 검색 버튼 선택 시
    }
    
    struct State {
        let labelDatas: Observable<[AnalysisSectionModel]>
        let segmentIndex: Observable<Int>
        let deepLink: Observable<String>
        let deepLinkError: Observable<PlatformError>
        let buttonActivation: Observable<Bool>
    }
    
    private let arr = ["스타일", "상의", "하의", "아우터", "원피스"]
    private var previousCategory = ""                       // 카테고리 비교 용도
    private var currentQuery = BehaviorRelay<String>(value: "")
    private var currentPlatform = BehaviorRelay<Platform?>(value: nil)
    private let topClassFilter: [String: [String]]           // CoreData Model 데이터 정재해서 저장 (큰 카테고리: [속성])
    
    private let _action = PublishSubject<Action>()
    private let _labelData = BehaviorRelay<[AnalysisSectionModel]>(value: [])
    private let _segmentIndex = BehaviorRelay(value: 0)
    private let _deepLink = PublishRelay<String>()
    private let _deepLinkError = PublishRelay<PlatformError>()
    private let _buttonActivation = BehaviorRelay(value: false)
    var action: AnyObserver<Action> { _action.asObserver() }
    
    public let state: State
    
    init(dummyUseCase: DummyUseCase, labelData: [LabelDataDisplay]) {
        self.dummyUseCase = dummyUseCase
        
        // 불러온 모델 데이터 ViewModel이 실아 있을 동안 전체 저장
        topClassFilter = [
            "스타일": labelData.filter { $0.topCategory == "스타일" }.prefix(3).map { $0.attributes },
            "상의": mapping("상의"),
            "하의": mapping("하의"),
            "아우터": mapping("아우터"),
            "원피스": mapping("원피스"),
        ]
        
        // 모델 데이터 정제 (일치율 40% 보다 큰 경우)
        func mapping(_ category: String) -> [String]{
            let att = labelData.filter { $0.topCategory == category && $0.probability > 40 }.map { $0.attributes }
            return att.isEmpty ? [emptyKeyword] : att
        }
        
        // 라벨 데이터 초기 세팅
        self._labelData.accept([
            AnalysisSectionModel(header: nil, type: .keyword, items: []),
            AnalysisSectionModel(header: topClassFilter.keys.map { String($0) }, type: .attribute, items: []),
            AnalysisSectionModel(header: nil, type: .platform, items: analysisSectionModel)
        ])
        
        
        
        state = State(labelDatas: _labelData.asObservable(),
                      segmentIndex: _segmentIndex.asObservable(),
                      deepLink: _deepLink.asObservable(),
                      deepLinkError: _deepLinkError.asObservable(),
                      buttonActivation: _buttonActivation.asObservable()
        )
        
        bindAction()
        buttonValidation()
    }
    
    /// 각 이벤트 별 이벤트 방출
    private func bindAction() {
        _action.subscribe(with: self) { owner, action in
            switch action {
            case let .didSelectedSegmentControl(category):
                owner.setItems(category: category)
            case let .didTapAttributeChip(attribute):
                owner.addKeyword(attribute)
            case let .didTapKeywordChip(keyword):
                owner.deleteKeyword(keyword)
            case let .didSubmitSearchText(attribute):
                owner.addKeyword(attribute)
            case let .didTapPlatformChip(platform):
                owner.selectePlatform(platform)
            case .didTapResetButton:
                owner.reset()
            case .didTapSearchButton:
                owner.movePlatform()
            }
        }.disposed(by: disposeBag)
    }
}

private extension AnalysisViewModel {
    
    /// 이미지 분석 후 카테고리에 따라 데이터 방출
    private func setItems(category: String) {
        // 이전 카테고리와 비교해서 같은 값이 방출되면 무시
        // RxDataSource에서 이벤트를 무한으로 방출하는 문제를 해결하기 위함
        if category != previousCategory {
            previousCategory = category
            let values = topClassFilter[category] ?? []
            var currentLabelData = _labelData.value
            
            // 이전 방출 데이터를 확인하기 위함
            let keywords = currentLabelData[0].items.map {
                guard case let .keyword(keyword) = $0 else { return "" }
                return keyword
            }
            currentLabelData[1].items = values.map {
                .attribute(attribute: $0, isSelected: keywords.contains($0))
            }
            _segmentIndex.accept(arr.firstIndex(where: { $0 == category} ) ?? 0)
            _labelData.accept(currentLabelData)
        }
    }
    
    /// 키워드 추가 이벤트
    private func addKeyword(_ keyword: String) {
        // 중복 추가 방지
        var currentLabelData = _labelData.value
        if !currentLabelData[0].items.contains(.keyword(keyword: keyword)) {
            currentLabelData[0].items.append(.keyword(keyword: keyword))
        }
        currentLabelData[1].items = currentLabelData[1].items.map { setAttributeButton($0, keyword: keyword, isSelected: true) }
        changedKeyword(labelData: currentLabelData)
        _labelData.accept(currentLabelData)
    }
    
    /// 키워드 삭제 이벤트
    private func deleteKeyword(_ keyword: String) {
        var currentLabelData = _labelData.value
        currentLabelData[0].items.removeAll(where: { $0 == .keyword(keyword: keyword) })
        currentLabelData[1].items = currentLabelData[1].items.map { setAttributeButton($0, keyword: keyword) }
        changedKeyword(labelData: currentLabelData)
        _labelData.accept(currentLabelData)
    }
    
    /// 플랫폼 선택 이벤트
    private func selectePlatform(_ platform: Platform) {
        var currentLabelData = _labelData.value
        
        currentPlatform.accept(platform)
        changedKeyword(labelData: currentLabelData)
        currentLabelData[2].items = currentLabelData[2].items.map { setAttributeButton($0, selectedPlatform: platform) }
        _labelData.accept(currentLabelData)
    }
    
    /// 옵션에 따라 데이터 상태 변경 후 반환
    private func setAttributeButton(_ item: AnalysisItem, keyword: String = "", selectedPlatform: Platform? = nil, isSelected: Bool = false) -> AnalysisItem{
        switch item {
        case let .attribute(attr, _) where attr == keyword:
            return .attribute(attribute: attr, isSelected: isSelected)
        case let .platform(platform, _):
            return .platform(platform: platform, isSelected: selectedPlatform?.platformName == platform.platformName)
        default:
            return item
        }
    }
    
    /// 초기화
    private func reset() {
        var value = _labelData.value
        value[0] = AnalysisSectionModel(header: nil, type: .keyword, items: [])
        _labelData.accept(value)
        _segmentIndex.accept(0)
    }
    
    /// 플랫폼 이동
    private func movePlatform() {
        currentPlatform
            .subscribe(with: self) { owner, platform in
                guard let link = platform?.platformDeepLink else {
                    owner._deepLinkError.accept(PlatformError.notFoundDeepLink)
                    return
                }
                if link != "notFound" {
                    owner._deepLink.accept(link)
                } else {
                    owner._deepLinkError.accept(PlatformError.preparePlatform)
                }
            }
            .disposed(by: disposeBag)
    }
    
    /// 키워드 변경 시 현제 쿼리 변경
    private func changedKeyword(labelData: [AnalysisSectionModel]) {
        let keyword = labelData[0].items.compactMap { item in
            if case let .keyword(keyword) = item { return keyword }
            return nil
        }
        let query = keyword.joined(separator: " ")
        var platform = currentPlatform.value
        
        switch currentPlatform.value?.platform {
        case .musinsa:
            platform?.platformDeepLink = ShopPlatform.musinsa.searchResultDeepLink(keyword: query)
        case .ably:
            platform?.platformDeepLink = ShopPlatform.ably.searchResultDeepLink(keyword: query)
        case .zigzag:
            platform?.platformDeepLink = ShopPlatform.zigzag.searchResultDeepLink(keyword: query)
        default: break
        }
        currentPlatform.accept(platform)
        currentQuery.accept(query)
    }
    
    /// 키워드와 플랫폼을 선택 하지 않았을 시 버튼 유효성 검사
    private func buttonValidation() {
        Observable
            .combineLatest(currentQuery, currentPlatform)
            .map { query, platform in
                return !query.isEmpty && platform != nil
            }
            .bind(to: _buttonActivation)
            .disposed(by: disposeBag)
    }
}
