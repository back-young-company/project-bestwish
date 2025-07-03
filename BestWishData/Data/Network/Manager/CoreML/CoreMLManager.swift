//
//  CoreMLManager.swift
//  BestWish
//
//  Created by Quarang on 6/23/25.
//

import BestWishDomain
import CoreML

/// CoreML 데이터 추출 매니저
public final class CoreMLManager {

    public init() {}
    
    /// 라벨 데이터 추출
    func fetchCoreMLLabelData(imageData: Data) throws -> [LabelDataEntity] {
        do {
            let model = try BestWidhClassfication()
            guard let buffer = imageData.toCVPixelBuffer() else { return [] }
            
            let output = try model.prediction(image: buffer)
            let labels = output.targetProbability
                .sorted(by: { $0.value > $1.value })
                .map {
                    LabelDataEntity(label: $0.key, probability: Int($0.value * 100))
                }
            return labels
        } catch {
            throw CoreMLError.modelLoadingFailed(error)
        }
    }
}
