//
//  LabelDataModel.swift
//  BestWish
//
//  Created by Quarang on 6/13/25.
//

import Foundation

/// 실제 뷰에서 사용할 데이터
struct LabelDataModel {
    let topCategory: String
    let subCategory: String
    let attributes: String
    let probability: Int
}

// MARK: - 데이터 매핑
extension LabelDataModel {
    static func convertToDisplay(from model: LabelData) -> LabelDataModel {
        let labelArray = model.label.split(separator: ":").map { String($0) }
        let (top, sub, attributes) = labelArray.count == 3 ? (labelArray[0], labelArray[1], labelArray[2]) : (labelArray[0], "", labelArray[1])
        return LabelDataModel(topCategory: top, subCategory: sub, attributes: attributes, probability: model.probability)
    }
}
