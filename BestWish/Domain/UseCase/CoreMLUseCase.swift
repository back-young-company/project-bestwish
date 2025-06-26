//
//  CoreMLUseCase.swift
//  BestWish
//
//  Created by Quarang on 6/17/25.
//

import UIKit

/// CoreML 유즈케이스
protocol CoreMLUseCase {
    /// 라벨 데이터 추출
    func fetchLabelDataModel(image: UIImage) throws -> [LabelData]
}

/// CoreML 유즈케이스 구현체
final class CoreMLUserCaseImpl: CoreMLUseCase {
    private let repository: CoreMLRepository
    
    init(repository: CoreMLRepository) {
        self.repository = repository
    }
    
    /// 라벨 데이터 추출
    func fetchLabelDataModel(image: UIImage) throws -> [LabelData] {
        return try repository.fetchCoreMLLabelData(image: image)
    }
}
