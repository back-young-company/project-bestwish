//
//  AnalysisSection.swift
//  BestWish
//
//  Created by Quarang on 6/13/25.
//

import RxDataSources

/// 각 섹션 아이템 케이스 정의
enum AnalysisItem: Equatable {
    case keyword(keyword: String)
    case attribute(attribute: String, isSelected: Bool)
    case platform(platform: PlatformEntity, isSelected: Bool = false)
}

/// AnalysisItem과 동일하지만 파라미터 없이 구분만을 위한 케이스
enum AnalysisSectionType: Int {
    case keyword = 0
    case attribute = 1
    case platform = 2
}

/// 실제로 사용한 섹션 모델
struct AnalysisSectionModel {
    var header: [String]?
    let type: AnalysisSectionType
    var items: [AnalysisItem]
}

// MARK: - 초기값 설정
extension AnalysisSectionModel: SectionModelType {
    typealias Item = AnalysisItem

    init(original: Self, items: [Item]) {
        self = original
        self.items = items
    }
}


