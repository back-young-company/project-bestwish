//
//  CoreMLManager.swift
//  BestWish
//
//  Created by Quarang on 6/23/25.
//

import Foundation
import CoreML
import UIKit

/// CoreML 데이터 추출 레포지토리
final class CoreMLManager {
    /// 라벨 데이터 추출
    func fetchCoreMLLabelData(image: UIImage) throws -> [LabelData] {
        let model = try BestWidhClassfication()
        guard let buffer = image.toCVPixelBuffer() else { return [] }
        
        let output = try model.prediction(image: buffer)
        let labels = output.targetProbability
            .sorted(by: { $0.value > $1.value })
            .map {
                LabelData(label: $0.key, probability: Int($0.value * 100))
            }
        return labels
    }
}
