//
//  CoreMLRepository.swift
//  BestWish
//
//  Created by Quarang on 6/17/25.
//

import UIKit

/// CoreML 레포지토리
protocol CoreMLRepository {
    /// 이미지에서 라벨데이터 추출
    func fetchCoreMLLabelData(image: UIImage) throws -> [LabelData]
}
