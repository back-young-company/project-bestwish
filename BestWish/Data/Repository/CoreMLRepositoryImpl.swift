//
//  CoreMLRepositoryImpl.swift
//  BestWish
//
//  Created by Quarang on 6/17/25.
//

import Foundation

/// CoreML 레포지토리
final class CoreMLRepositoryImpl: CoreMLRepository {
    
    private let manager: CoreMLManager
    
    init(manager: CoreMLManager) {
        self.manager = manager
    }
    
    /// 라벨 데이터 추출
    func fetchCoreMLLabelData(imageData: Data) throws -> [LabelDataEntity] {
        do {
            let labels = try manager.fetchCoreMLLabelData(imageData: imageData)
            return labels
        } catch let error as AppError {
            throw error
        }
    }
}
