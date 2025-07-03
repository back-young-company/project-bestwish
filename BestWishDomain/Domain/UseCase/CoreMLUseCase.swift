//
//  CoreMLUseCase.swift
//  BestWish
//
//  Created by Quarang on 6/17/25.
//
import Foundation

/// CoreML 유즈케이스
public protocol CoreMLUseCase {
    /// 라벨 데이터 추출
    func fetchLabelDataModel(imageData: Data) throws -> [LabelDataEntity]
}

/// CoreML 유즈케이스 구현체
public final class CoreMLUserCaseImpl: CoreMLUseCase {
    private let repository: CoreMLRepository
    
    public init(repository: CoreMLRepository) {
        self.repository = repository
    }
    
    /// 라벨 데이터 추출
    public func fetchLabelDataModel(imageData: Data) throws -> [LabelDataEntity] {
        return try repository.fetchCoreMLLabelData(imageData: imageData)
    }
}
