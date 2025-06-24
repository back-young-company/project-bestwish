//
//  AblyFetcher.swift
//  BestWish
//
//  Created by 백래훈 on 6/9/25.
//

import Foundation

import RxSwift

/// 에이블리 Fetcher
final class AblyFetcher: ProductDTOFetcher {
    /// 상품 데이터 fetch
    func fetchProductDTO(ogUrl: URL, extraUrl: URL) async throws -> ProductDTO {
        let (data, _) = try await URLSession.shared.data(from: extraUrl)
        guard let html = String(data: data, encoding: .utf8) else {
            throw ShareExtensionError.dataLoadingFailed
        }
        guard let nextDataJSON = html.extractNEXTDataJSON(),
              let jsonData = nextDataJSON.data(using: .utf8) else {
            throw ShareExtensionError.jsonScriptParsingFailed
        }

        do {
            let decoded = try JSONDecoder().decode(AblyResponseDTO.self, from: jsonData)
            guard let goods = decoded.props.serverQueryClient.queries.first?.state.data.goods,
                  let sno = goods.sno else {
                throw ShareExtensionError.invalidProductData
            }

            let deeplink = "ably://goods/\(sno)"

            return ProductDTO(
                id: nil,
                userID: nil,
                platform: 3,
                title: goods.name,
                price: goods.priceInfo.thumbnailPrice,
                discountRate: String(goods.priceInfo.discountRate ?? 0),
                brand: goods.market.name,
                imagePathURL: goods.coverImages.first,
                productURL: deeplink,
                createdAt: nil
            )
        } catch {
            throw ShareExtensionError.jsonDecodingFailed
        }
    }
}
