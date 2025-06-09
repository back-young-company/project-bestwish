//
//  ZigzagFetcher.swift
//  BestWish
//
//  Created by 백래훈 on 6/9/25.
//

import Foundation

import RxSwift

// MARK: - Zigzag Fetcher
class ZigzagFetcher: HTMLBasedMetadataFetcher {
    func fetchMetadata(from url: URL, html: String) -> Single<ProductMetadataDTO> {
        return Single<ProductMetadataDTO>.create { single in
            let brand = html.slice(from: "property=\"product:brand\" content=\"", to: "\"")
            let title = html.slice(from: "property=\"og:title\" content=\"", to: "\"")
            let image = html.slice(from: "property=\"og:image\" content=\"", to: "\"")
            let amountPrice = html.slice(from: "property=\"product:price:amount\" content=\"", to: "\"")

            let metadata = ProductMetadataDTO(
                productName: title,
                brandName: brand,
                discountRate: "0",
                price: amountPrice,
                imageURL: image,
                productURL: url,
                extra: nil
            )
            single(.success(metadata))
            return Disposables.create()
        }
    }
}
