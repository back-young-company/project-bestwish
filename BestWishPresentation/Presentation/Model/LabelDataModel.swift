//
//  LabelDataModel.swift
//  BestWish
//
//  Created by Quarang on 6/13/25.
//

import BestWishDomain
import Foundation

/// 실제 뷰에서 사용할 데이터
struct LabelDataModel {
    let topCategory: String
    var attributes: [String]
}

// MARK: - 데이터 매핑
extension LabelDataModel {
    
    /// 라벨 데이터 Entity -> Model
    static func convertToModel(for entitys: [LabelDataEntity]) -> [LabelDataModel] {
        // 최상위 클래스와 속성으로만 구분
        let models: [(top: String, attr: String, prob: Int)] = entitys.map { entity in
            let labels = entity.label.split(separator: ":").map { String($0) }
            return (labels[0], (labels.count == 3 ? labels[2] : labels[1]), entity.probability)
        }
        let style = LabelDataModel(topCategory: "스타일", attributes: models.filter { $0.top == "스타일" }.prefix(3).map { $0.attr })
        let top = LabelDataModel(topCategory: "상의", attributes: models.filter { $0.top == "상의" && $0.prob > 40 }.map { $0.attr })
        let bottom = LabelDataModel(topCategory: "하의", attributes: models.filter { $0.top == "하의" && $0.prob > 40 }.map { $0.attr })
        let outer = LabelDataModel(topCategory: "아우터", attributes: models.filter { $0.top == "아우터" && $0.prob > 40 }.map { $0.attr })
        let onePiece = LabelDataModel(topCategory: "원피스", attributes: models.filter { $0.top == "원피스" && $0.prob > 40 }.map { $0.attr })
        return [style, top, bottom, outer, onePiece]
    }
}
