//
//  PlatformSearchUseCase.swift
//  BestWish
//
//  Created by Quarang on 6/17/25.
//

/// 이미지 분석 유즈 케이스
protocol AnalysisUseCase {
    /// 키워드 추가 이벤트
    func addKeyword(_ keyword: String, models: [AnalysisSectionModel]) -> [AnalysisSectionModel]
    /// 키워드 삭제 이벤트
    func deleteKeyword(_ keyword: String, models: [AnalysisSectionModel]) -> [AnalysisSectionModel]
    /// 플랫폼 선택 이벤트
    func selectePlatform(_ platform: PlatformItem, models: [AnalysisSectionModel]) -> [AnalysisSectionModel]
    /// 초기화
    func resetKeyword(models: [AnalysisSectionModel]) -> [AnalysisSectionModel]
    /// 플랫폼 이동
    func movePlatform(platform: PlatformItem?) throws -> String
    /// 속성 버튼 세팅
    func setAttributeButton(_ item: AnalysisItem, keyword: String, selectedPlatform: PlatformItem?, isSelected: Bool) -> AnalysisItem
}

/// 이미지 분석 유즈 케이스 구현체
final class AnalysisUseCaseImpl: AnalysisUseCase {
    
    /// 키워드 추가 이벤트
    func addKeyword(_ keyword: String, models: [AnalysisSectionModel]) -> [AnalysisSectionModel] {
        var models = models
        if !models[0].items.contains(.keyword(keyword: keyword)) {
            models[0].items.append(.keyword(keyword: keyword))
        }
        models[1].items = models[1].items.map { setAttributeButton($0, keyword: keyword, isSelected: true) }
        return models
    }
    
    /// 키워드 삭제 이벤트
    func deleteKeyword(_ keyword: String, models: [AnalysisSectionModel]) -> [AnalysisSectionModel] {
        var models = models
        models[0].items.removeAll(where: { $0 == .keyword(keyword: keyword) })
        models[1].items = models[1].items.map { setAttributeButton($0, keyword: keyword) }
        return models
    }
    
    /// 플랫폼 선택 이벤트
    func selectePlatform(_ platform: PlatformItem, models: [AnalysisSectionModel]) -> [AnalysisSectionModel] {
        var models = models
        models[2].items = models[2].items.map { setAttributeButton($0, selectedPlatform: platform) }
        return models
    }
    
    /// 초기화
    func resetKeyword(models: [AnalysisSectionModel]) -> [AnalysisSectionModel] {
        var models = models
        models[0] = AnalysisSectionModel(header: nil, type: .keyword, items: [])
        return models
    }
    
    /// 플랫폼 이동
    func movePlatform(platform: PlatformItem?) throws -> String {
        guard let link = platform?.platformDeepLink else {
            throw PlatformError.notFoundDeepLink
        }
        if link != "notFound" {
            return link
        } else {
            throw PlatformError.preparePlatform
        }
    }
    
    /// 속성 버튼 세팅
    func setAttributeButton(_ item: AnalysisItem, keyword: String = "", selectedPlatform: PlatformItem? = nil, isSelected: Bool = false) -> AnalysisItem {
        switch item {
        case let .attribute(attr, _) where attr == keyword:
            return .attribute(attribute: attr, isSelected: isSelected)
        case let .platform(platform, _):
            return .platform(platform: platform, isSelected: selectedPlatform?.platformName == platform.platformName)
        default:
            return item
        }
    }
}
