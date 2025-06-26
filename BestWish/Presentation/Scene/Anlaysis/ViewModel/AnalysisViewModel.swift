//
//  AnalysisViewModel.swift
//  BestWish
//
//  Created by Quarang on 6/12/25.
//
import Foundation

import RxRelay
import RxSwift

/// 이미지 분석 ViewModel
final class AnalysisViewModel: ViewModel {
    
    // MARK: - Action
    enum Action {
        case viewDidLoad                                    // View가 로드될 시
        case didSelectedSegmentControl(category: String)    // 세그먼트 컨트롤 선택 시
        case didTapAttributeChip(attribute: String)         // 속성 칩 선택 시
        case didSubmitSearchText(keyword: String)           // 검색버튼 터치 시
        case didTapKeywordChip(keyword: String)             // 키워드 칩 선택 시
        case didTapPlatformChip(platform: PlatformItem)     // 플랫폼 칩 선택 시
        case didTapResetButton                              // 초기화 버튼 선택 시
        case didTapSearchButton                             // 검색 버튼 선택 시
    }
    
    // MARK: - State
    struct State {
        let models: Observable<[AnalysisSectionModel]>
        let segmentIndex: Observable<Int>
        let deepLink: Observable<String>
        let deepLinkError: Observable<PlatformError>
        let buttonActivation: Observable<Bool>
    }
    
    // MARK: - Internal Property
    var action: AnyObserver<Action> { _action.asObserver() }
    let state: State
    
    // MARK: - Private Property
    private var previousCategory = ""                       // 카테고리 비교 용도
    private var currentQuery = BehaviorRelay<String>(value: "")
    private var currentPlatform = BehaviorRelay<PlatformItem?>(value: nil)
    
    private let _action = PublishSubject<Action>()
    
    private let _models = BehaviorRelay<[AnalysisSectionModel]>(value: [])
    private let _segmentIndex = BehaviorRelay(value: 0)
    private let _deepLink = PublishRelay<String>()
    private let _deepLinkError = PublishRelay<PlatformError>()
    private let _buttonActivation = BehaviorRelay(value: false)
    
    private let analysisUseCase: AnalysisUseCase
    private let labelDataModels: [LabelDataModel]
    private let disposeBag = DisposeBag()
    
    private var keywords: [String] {
        _models.value[0].items.compactMap {
            if case let .keyword(keyword) = $0 {
                return keyword
            }
            return nil
        }
    }
    
    private var attributes: [String] {
        _models.value[1].items.compactMap {
            if case let .attribute(attribute, _) = $0 {
                return attribute
            }
            return nil
        }
    }
    
    private var platforms: [PlatformItem] {
        _models.value[2].items.compactMap {
            if case let .platform(platform, _) = $0 {
                return platform
            }
            return nil
        }
    }
    
    
    init(analysisUseCase: AnalysisUseCase, labelData: [LabelDataEntity]) {
        self.analysisUseCase = analysisUseCase
        self.labelDataModels = LabelDataModel.convertToModel(for: labelData)
        
        state = State(
            models: _models.asObservable(),
            segmentIndex: _segmentIndex.asObservable(),
            deepLink: _deepLink.asObservable(),
            deepLinkError: _deepLinkError.asObservable(),
            buttonActivation: _buttonActivation.asObservable()
        )
        
        bindAction()
    }
    
    /// 각 이벤트 별 이벤트 방출
    private func bindAction() {
        _action.subscribe(with: self) { owner, action in
            switch action {
            case .viewDidLoad:
                owner.setSectionModel()
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
    
    /// 섹션 모델 초기화
    private func setSectionModel() {
        let analysisSectionModel = [
            AnalysisSectionModel(header: nil, type: .keyword, items: []),
            AnalysisSectionModel(header: nil, type: .attribute, items: []),
            AnalysisSectionModel(header: nil, type: .platform, items: PlatformEntity.allCases.filter{ $0 != .all }.map {
                .platform(platform: PlatformItem(
                    platform: $0,
                    platformName: $0.platformName,
                    platformImage: $0.platformImage,
                    platformDeepLink: $0.platformDeepLink
                ))
            })
        ]
        // 라벨 데이터 초기 세팅
        _models.accept(analysisSectionModel)
        buttonValidation()
    }
    
    /// 이미지 분석 후 카테고리에 따라 데이터 방출
    private func setItems(category: String) {
        // 이전 카테고리와 비교해서 같은 값이 방출되면 무시
        // RxDataSource에서 이벤트를 무한으로 방출하는 문제를 해결하기 위함
        guard category != previousCategory else { return }
        previousCategory = category
        guard var attributes = labelDataModels.first(where: { $0.topCategory == category })?.attributes else { return }
        
        if attributes.isEmpty {
            attributes.append(String.emptyKeyword)
        }
        // 아이템 체인지
        changeItem(type: .attribute) {
            attributes.compactMap {
                AnalysisItem.attribute(attribute: $0, isSelected: true)
            }
        }
        _segmentIndex.accept(labelDataModels.firstIndex(where: { $0.topCategory == category} ) ?? 0)
    }
    
    /// 키워드 추가 이벤트
    private func addKeyword(_ keyword: String) {
        var keywords = keywords
        let changedKeywords = analysisUseCase.addKeyword(keyword, keywords: &keywords)
        
        // 키워드 추가
        changeItem(type: .keyword) {
            changedKeywords.map {
                .keyword(keyword: $0)
            }
        }
        // 현제 검색어 업데이트
        currentQuery.accept(keywords.joined(separator: " "))
    }
    
    /// 키워드 삭제 이벤트
    private func deleteKeyword(_ keyword: String) {
        var keywords = keywords
        let changedKeywords = analysisUseCase.deleteKeyword(keyword, keywords: &keywords)
        
        // 키워드 추가
        changeItem(type: .keyword) {
            changedKeywords.map {
                .keyword(keyword: $0)
            }
        }
        // 현제 검색어 업데이트
        currentQuery.accept(keywords.joined(separator: " "))
    }
    
    /// 플랫폼 선택 이벤트
    private func selectePlatform(_ platform: PlatformItem) {
        changeItem(type: .platform) {
            platforms.map {
                .platform(platform: $0, isSelected: $0 == platform)
            }
        }
        // 현제 플랫폼 업데이트
        currentPlatform.accept(platform)
    }
    
    /// 초기화
    private func resetKeyword() {
        var models = _models.value
        models[0] = AnalysisSectionModel(header: nil, type: .keyword, items: [])
        _models.accept(models)
        _segmentIndex.accept(0)
        
        currentQuery.accept("")
        currentPlatform.accept(nil)
    }
    
    /// 플랫폼 이동
    private func movePlatform() {
        do {
            let query = currentQuery.value
            let deepLink = currentPlatform.value?.platform?.searchResultDeepLink(keyword: query)
            
            let link = try analysisUseCase.movePlatform(deepLink: deepLink)
            _deepLink.accept(link)
        } catch let error  {
            guard let error = error as? PlatformError else { return }
            _deepLinkError.accept(error)
        }
    }
}

// MARK: - 내부 메서드
private extension AnalysisViewModel {
    /// sectionModel의 데이터를 바꾸는 메서드
    private func changeItem(type: AnalysisSectionType, completion: () -> [AnalysisItem]) {
        var models = _models.value
        
        switch type {
        case .keyword, .attribute:
            // 키워드 추가
            if type == .keyword {
                models[0].items = completion()
            } else {
                models[1].items = completion()
            }
            
            let keywords = models[0].items.compactMap {
                if case let .keyword(keyword) = $0 { return keyword }
                return nil
            }
            // 키워드가 있을 경우
            models[1].items = models[1].items.compactMap {
                if case let .attribute(attribute, _) = $0 {
                    return AnalysisItem.attribute(attribute: attribute, isSelected: !keywords.contains(attribute))
                }
                return nil
            }
        case .platform:
            models[2].items = completion()
        }
        _models.accept(models)
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
