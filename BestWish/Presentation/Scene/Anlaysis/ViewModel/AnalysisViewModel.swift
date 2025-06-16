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
    }
    
    struct State {
        let labelDatas: Observable<[AnalysisSectionModel]>
    }
    
    private var previousCategory = ""                       // 카테고리 비교 용도
    private let _action = PublishSubject<Action>()
    private let _labelData = BehaviorRelay<[AnalysisSectionModel]>(value: [])
    
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
        
        // 모델 데이터 정제 (일치율 40% 이상만)
        func mapping(_ category: String) -> [String]{
            let att = labelData.filter { $0.topCategory == category && $0.probability > 40 }.map { $0.attributes }
            return att.isEmpty ? [emptyKeyword] : att
        }
        
        // 라벨 데이터 초기 세팅
        self._labelData.accept([
            AnalysisSectionModel(header: nil, type: .keyword, items: []),
            AnalysisSectionModel(header: topClassFilter.keys.map { String($0) }, type: .attribute, items: []),
            AnalysisSectionModel(header: nil, type: .platform, items: [
                .platform(platform: Platform(platformName: "무신사", platformImage: PlatformImage.musinsa)),
                .platform(platform: Platform(platformName: "지그재그", platformImage: PlatformImage.zigzag)),
                .platform(platform: Platform(platformName: "에이블리", platformImage: PlatformImage.ably)),
                .platform(platform: Platform(platformName: "브랜디", platformImage: PlatformImage.brandy))
            ])
        ])
        
        state = State(labelDatas: _labelData.asObservable())
        
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
            }
        }.disposed(by: disposeBag)
    }
}

private extension AnalysisViewModel {
    
    /// 이미지 분석 후 카테고리에 따라 데이터 방출
    private func setItems(category: String) {
        // 이전 카테고리와 비교해서 같은 값이 방출되면 무시
        // RxDataSource에서 이벤트를 무하능로 방출하는 문제를 해결하기 위함
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
        _labelData.accept(currentLabelData)
    }
    
    /// 키워드 삭제 이벤트
    private func deleteKeyword(_ keyword: String) {
        var currentLabelData = _labelData.value
        currentLabelData[0].items.removeAll(where: { $0 == .keyword(keyword: keyword) })
        currentLabelData[1].items = currentLabelData[1].items.map { setAttributeButton($0, keyword: keyword) }
        _labelData.accept(currentLabelData)
    }
    
    /// 플랫폼 선택 이벤트
    private func selectePlatform(_ platform: Platform) {
        var currentLabelData = _labelData.value
        currentLabelData[2].items = currentLabelData[2].items.map { setAttributeButton($0, selectedPlatform: platform) }
        _labelData.accept(currentLabelData)
    }
    
    /// 옵션에 따라 데이터 상태 변경 후 반환
    private func setAttributeButton(_ item: AnalysisItem, keyword: String = "", selectedPlatform: Platform? = nil, isSelected: Bool = false) -> AnalysisItem{
        switch item {
        case let .attribute(attr, _) where attr == keyword:
            return .attribute(attribute: attr, isSelected: isSelected)
        case let .platform(platform, _):
            return .platform(platform: platform, isSelected: selectedPlatform == platform)
        default:
            return item
        }
    }
}
