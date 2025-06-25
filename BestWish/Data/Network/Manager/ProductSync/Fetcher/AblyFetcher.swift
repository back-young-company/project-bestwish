//
//  AblyFetcher.swift
//  BestWish
//
//  Created by 백래훈 on 6/9/25.
//

import Foundation

import RxSwift

/// 에이블리 Fetcher
final class AblyFetcher: ProductDTORepository {
    /// 상품 데이터 fetch
    func fetchProductDTO(ogUrl: URL?, finalUrl: URL?, html: String?) async throws -> ProductDTO {
        guard let json = html?.extractNEXTDataJSON(),
              let jsonData = json.data(using: .utf8) else {
            throw ProductSyncError.jsonScriptParsingFailed
        }

        do {
            let decoded = try JSONDecoder().decode(AblyResponseDTO.self, from: jsonData)
            guard let goods = decoded.props.serverQueryClient.queries.first?.state.data.goods,
                  let sno = goods.sno else {
                throw ProductSyncError.invalidProductData
            }

            return ProductDTO(
                id: nil,
                userID: nil,
                platform: 3,
                title: goods.name,
                price: goods.priceInfo.thumbnailPrice,
                discountRate: String(goods.priceInfo.discountRate ?? 0),
                brand: goods.market.name,
                imagePathURL: goods.coverImages.first,
                productURL: "ably://goods/\(sno)",
                createdAt: nil
            )
        } catch {
            throw ProductSyncError.jsonDecodingFailed
        }
    }
}
