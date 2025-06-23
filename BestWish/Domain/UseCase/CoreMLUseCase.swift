//
//  CoreMLUseCase.swift
//  BestWish
//
//  Created by Quarang on 6/17/25.
//

import UIKit

// MARK: - CoreML 유즈케이스
protocol CoreMLUseCase {
    func fetchLabelDataModel(image: UIImage) throws -> [LabelData]
}

// MARK: - CoreML 유즈케이스 구현체
final class CoreMLUserCaseImpl: CoreMLUseCase {
    private let repository: CoreMLRepository
    
    init(repository: CoreMLRepository) {
        self.repository = repository
    }
    
    func fetchLabelDataModel(image: UIImage) throws -> [LabelData] {
        return try repository.fetchCoreMLLabelData(image: image)
    }
}
