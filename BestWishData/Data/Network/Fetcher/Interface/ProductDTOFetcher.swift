//
//  ProductDTOFetcher.swift
//  BestWish
//
//  Created by 백래훈 on 6/9/25.
//

import Foundation

internal import RxSwift

/// 외부 플랫폼의 상품 정보 -> ProductDTO 변환 역할의 프로토콜
protocol ProductDTOFetcher {
    /// 상품 데이터 fetch
    func fetchProductDTO(deepLink: URL?, productURL: URL?, html: String?) async throws -> ProductDTO
}
