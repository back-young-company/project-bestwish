//
//  MusinsaFetcher.swift
//  BestWish
//
//  Created by 백래훈 on 6/9/25.
//

import Foundation

import RxSwift

// MARK: - Musinsa Fetcher
class MusinsaFetcher: ShareMetadataFetcher {
    func fetchMetadata(ogUrl: URL, extraUrl: URL) -> Single<ProductMetadataDTO> {
        return Single<ProductMetadataDTO>.create { single in
            let task = URLSession.shared.dataTask(with: extraUrl) { data, _, error in
                guard let data, let html = String(data: data, encoding: .utf8) else {
                    single(.failure(error ?? ShareExtensionError.dataLoadingFailed))
                    return
                }
                // HTML에서 리디렉션된 상품 URL 확인
                if let productURLString = html.firstMatch(for: #"link=(https:\/\/www\.musinsa\.com\/products\/\d+)"#),
                   let redirectedURL = URL(string: productURLString),
                   redirectedURL != extraUrl {
                    // 리디렉션된 URL이 현재 URL과 다를 때만 재귀 호출
                    _ = self.fetchMetadata(ogUrl: ogUrl, extraUrl: redirectedURL).subscribe(single)
                    return
                }
                
                let title = html.slice(from: "property=\"og:title\" content=\"", to: "\"")
                let image = html.slice(from: "property=\"og:image\" content=\"", to: "\"")
                let saleRate = html.slice(from: "property=\"product:price:sale_rate\" content=\"", to: "\"")
                let amountPrice = html.slice(from: "property=\"product:price:amount\" content=\"", to: "\"")
                // Parse brand and product name
                let (brand, product, extra) = MusinsaFetcher.parseTitle(title ?? "")
                let metadata = ProductMetadataDTO(
                    platform: 1,
                    productName: product,
                    brandName: brand,
                    discountRate: saleRate,
                    price: amountPrice,
                    imageURL: image,
                    productURL: ogUrl,
                    extra: extra
                )
                single(.success(metadata))
            }
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }

    private static func parseTitle(_ title: String) -> (brand: String?, product: String?, extra: String?) {
        guard let firstSpaceRange = title.range(of: " ") else {
            return (nil, nil, nil)
        }
        let brand = String(title[..<firstSpaceRange.lowerBound])
        let remainder = String(title[firstSpaceRange.upperBound...])
        let productAndExtra = remainder.components(separatedBy: " - ")
        let product = productAndExtra.first
        let extra = productAndExtra.count > 1 ? productAndExtra[1] : nil
        return (brand, product, extra)
    }
}
