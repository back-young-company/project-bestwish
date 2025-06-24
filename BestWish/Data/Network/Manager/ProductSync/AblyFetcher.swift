//
//  AblyFetcher.swift
//  BestWish
//
//  Created by 백래훈 on 6/9/25.
//

import Foundation

import RxSwift

/// 에이블리 Fetcher
final class AblyFetcher: ShareMetadataFetcher {
    func fetchMetadata(ogUrl: URL, extraUrl: URL) async throws -> ProductMetadataDTO {
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

            return ProductMetadataDTO(
                platform: 3,
                productName: goods.name,
                brandName: goods.market.name,
                discountRate: "\(goods.priceInfo.discountRate ?? 0)",
                price: "\(goods.priceInfo.thumbnailPrice ?? 0)",
                imageURL: goods.coverImages.first,
                productURL: URL(string: deeplink),
                extra: nil
            )
        } catch {
            throw ShareExtensionError.jsonDecodingFailed
        }
    }
}
