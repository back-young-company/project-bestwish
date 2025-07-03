//
//  LabelData.swift
//  BestWish
//
//  Created by Quarang on 6/13/25.
//

import Foundation

/// 처음 CoreML 모델에서 추출한 데이터
public struct LabelDataEntity {
    public let label: String
    public let probability: Int

    public init(label: String, probability: Int) {
        self.label = label
        self.probability = probability
    }
}
