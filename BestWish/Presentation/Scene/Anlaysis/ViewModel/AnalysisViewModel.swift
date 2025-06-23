//
//  AnalysisViewModel.swift
//  BestWish
//
//  Created by Quarang on 6/12/25.
//

import RxSwift
import RxRelay

/// 이미지 분석 ViewModel
final class AnalysisViewModel: ViewModel {
    
    // MARK: - Action
    enum Action {
        case didSelectedSegmentControl(category: String)    // 세그먼트 컨트롤 선택 시
        case didTapAttributeChip(attribute: String)         // 속성 칩 선택 시
        case didSubmitSearchText(keyword: String)           // 검색버튼 터치 시
        case didTapKeywordChip(keyword: String)             // 키워드 칩 선택 시
        case didTapPlatformChip(platform: Platform)         // 플랫폼 칩 선택 시
        case didTapResetButton                              // 초기화 버튼 선택 시
        case didTapSearchButton                             // 검색 버튼 선택 시
    }
    
    // MARK: - State
    struct State {
        let labelDatas: Observable<[AnalysisSectionModel]>
        let segmentIndex: Observable<Int>
        let deepLink: Observable<String>
        let deepLinkError: Observable<PlatformError>
        let buttonActivation: Observable<Bool>
    }
    
    // MARK: - Internal Property
    var action: AnyObserver<Action> { _action.asObserver() }
    let state: State
    
    // MARK: - Private Property
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
    
    private let labelData: [LabelDataDisplay]
    private let analysisUseCase: AnalysisUseCase
    private let disposeBag = DisposeBag()
    
    init(analysisUseCase: AnalysisUseCase, labelData: [LabelDataDisplay]) {
        self.analysisUseCase = analysisUseCase
        self.labelData = labelData
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
            let emptyKeyword = "해당 카테고리의 키워드를 인식할 수 없습니다."          // 비어 있는 키워드 예외처리를 위함
            let att = labelData.filter { $0.topCategory == category && $0.probability > 40 }.map { $0.attributes }
            return att.isEmpty ? [emptyKeyword] : att
        }
        
        let analysisSectionModel:[AnalysisSectionModel] = [
            AnalysisSectionModel(header: nil, type: .keyword, items: []),
            AnalysisSectionModel(header: topClassFilter.keys.map { String($0) }, type: .attribute, items: []),
            AnalysisSectionModel(header: nil, type: .platform, items: ShopPlatform.allCases.filter{ $0 != .all }.map {
                .platform(platform: Platform(
                    platform: $0,
                    platformName: $0.platformName,
                    platformImage: $0.rawValue,
                    platformDeepLink: $0.platformDeepLink
                ))
            })
        ]
        
        // 라벨 데이터 초기 세팅
        self._labelData.accept(analysisSectionModel)
        
        state = State(
            labelDatas: _labelData.asObservable(),
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
                owner.resetKeyword()
            case .didTapSearchButton:
                owner.movePlatform()
            }
        }.disposed(by: disposeBag)
    }
}


// MARK: - 비즈니스 로직
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
        let models = analysisUseCase.addKeyword(keyword, models: _labelData.value)
        changedKeyword(labelData: models)
        _labelData.accept(models)
    }
    
    /// 키워드 삭제 이벤트
    private func deleteKeyword(_ keyword: String) {
        let models = analysisUseCase.deleteKeyword(keyword, models: _labelData.value)
        changedKeyword(labelData: models)
        _labelData.accept(models)
    }
    
    /// 플랫폼 선택 이벤트
    private func selectePlatform(_ platform: Platform) {
        let models = analysisUseCase.selectePlatform(platform, models: _labelData.value)
        currentPlatform.accept(platform)
        changedKeyword(labelData: models)
        _labelData.accept(models)
    }
    
    /// 초기화
    private func resetKeyword() {
        let models = analysisUseCase.resetKeyword(models: _labelData.value)
        _labelData.accept(models)
        _segmentIndex.accept(0)
    }
    
    /// 플랫폼 이동
    private func movePlatform() {
        do {
            let link = try analysisUseCase.movePlatform(platform: currentPlatform.value)
            _deepLink.accept(link)
        } catch let error  {
            guard let error = error as? PlatformError else { return }
            _deepLinkError.accept(error)
        }
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
