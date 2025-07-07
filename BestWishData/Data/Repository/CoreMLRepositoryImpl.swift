//
//  CoreMLRepositoryImpl.swift
//  BestWish
//
//  Created by Quarang on 6/17/25.
//

import BestWishDomain
import Foundation

/// CoreML 레포지토리
public final class CoreMLRepositoryImpl: CoreMLRepository {

    private let manager: CoreMLManager
    
    public init(manager: CoreMLManager) {
        self.manager = manager
    }
    
    /// 라벨 데이터 추출
    public func fetchCoreMLLabelData(imageData: Data) throws -> [LabelDataEntity] {
        do {
            let labels = try manager.fetchCoreMLLabelData(imageData: imageData)
            return labels
        } catch let error as AppError {
            throw error
        }
    }
}
