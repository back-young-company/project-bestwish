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
    }
    
    private let arr = ["스타일", "상의", "하의", "아우터", "원피스"]
    private var previousCategory = ""                       // 카테고리 비교 용도
    private var currentQuery = ""
    private var currentPlatform: Platform?
    
    private let _action = PublishSubject<Action>()
    private let _labelData = BehaviorRelay<[AnalysisSectionModel]>(value: [])
    private let _segmentIndex = BehaviorRelay(value: 0)
    private let _deepLink = PublishSubject<String>()
    var action: AnyObserver<Action> { _action.asObserver() }
    
    public let topClassFilter: [String: [String]]           // CoreData Model 데이터 정재해서 저장 (큰 카테고리: [속성])
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
            AnalysisSectionModel(header: nil, type: .platform, items: [
                .platform(platform: Platform(platform: .musinsa, platformName: "무신사", platformImage: PlatformImage.musinsa, platformDeepLink: "")),
                .platform(platform: Platform(platform: .zigzag, platformName: "지그재그", platformImage: PlatformImage.zigzag, platformDeepLink: "")),
                .platform(platform: Platform(platform: .ably, platformName: "에이블리", platformImage: PlatformImage.ably, platformDeepLink: ""))
            ])
        ])
        
        state = State(labelDatas: _labelData.asObservable(),
                      segmentIndex: _segmentIndex.asObservable(),
                      deepLink: _deepLink.asObservable()
        )
        
        bindAction()
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
        print(currentQuery)
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
        
        currentPlatform = platform
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
        _deepLink.onNext(currentPlatform?.platformDeepLink ?? "")
    }
    
    /// 키워드 변경 시 현제 쿼리 변경
    private func changedKeyword(labelData: [AnalysisSectionModel]) {
        let keyword = labelData[0].items.compactMap { item in
            if case let .keyword(keyword) = item { return keyword }
            return nil
        }
        currentQuery = keyword.joined(separator: " ")
    
        switch currentPlatform?.platform {
        case .musinsa:
            currentPlatform?.platformDeepLink = ShopPlatform.musinsa.searchResultDeepLink(keyword: currentQuery)
        case .ably:
            currentPlatform?.platformDeepLink = ShopPlatform.ably.searchResultDeepLink(keyword: currentQuery)
        case .zigzag:
            currentPlatform?.platformDeepLink = ShopPlatform.zigzag.searchResultDeepLink(keyword: currentQuery)
        default: break
        }
    }
}
