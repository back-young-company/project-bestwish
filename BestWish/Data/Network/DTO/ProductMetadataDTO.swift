//
//  ProductMetadataDTO.swift
//  BestWish
//
//  Created by 백래훈 on 6/9/25.
//

import Foundation

// MARK: - 상품 메타데이터 모델
struct ProductMetadataDTO {
    let platform: Int?
    let productName: String?
    let brandName: String?
    let discountRate: String?
    let price: String?
    let imageURL: String?
    let productURL: URL?
    let extra: String?
    
    func toEntity() -> ProductMetadata {
        return ProductMetadata(
            productName: productName,
            brandName: brandName,
            platform: platform,
            discountRate: discountRate,
            price: Int(price ?? "0"),
            imageURL: imageURL,
            productURL: productURL?.absoluteString
        )
    }
}
