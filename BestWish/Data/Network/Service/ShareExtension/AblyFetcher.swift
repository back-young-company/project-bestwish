//
//  AblyFetcher.swift
//  BestWish
//
//  Created by 백래훈 on 6/9/25.
//

import Foundation

import RxSwift

// MARK: - Ably Fetcher
class AblyFetcher: ShareMetadataFetcher {
    func fetchMetadata(ogUrl: URL, extraUrl: URL) -> Single<ProductMetadataDTO> {
        return Single<ProductMetadataDTO>.create { single in
            let task = URLSession.shared.dataTask(with: extraUrl) { data, _, error in
                guard let data, let html = String(data: data, encoding: .utf8) else {
                    single(.failure(error ?? NSError(domain: "AblyFetcher", code: -1)))
                    return
                }
                guard let nextDataJSON = html.extractNEXTDataJSON(),
                      let jsonData = nextDataJSON.data(using: .utf8) else {
                    single(.failure(NSError(domain: "AblyFetcher", code: -2)))
                    return
                }
                do {
                    let decoded = try JSONDecoder().decode(AblyResponseDTO.self, from: jsonData)
                    let goods = decoded.props.serverQueryClient.queries.first?.state.data.goods
                    let metadata = ProductMetadataDTO(
                        productName: goods?.name,
                        brandName: goods?.market.name,
                        discountRate: "\(goods?.priceInfo.discountRate ?? 0)",
                        price: "\(goods?.priceInfo.thumbnailPrice ?? 0)",
                        imageURL: goods?.coverImages.first,
                        productURL: extraUrl,
                        extra: nil
                    )
                    single(.success(metadata))
                } catch {
                    single(.failure(error))
                }
            }
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
}
