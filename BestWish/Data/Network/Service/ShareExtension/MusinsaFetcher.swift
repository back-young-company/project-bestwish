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
                
                if let json = html.extractNEXTDataJSON() {
                    let goodsNm = #""goodsNm"\s*:\s*"([^"]+)""#
                    let thumbnailImageUrl = #""thumbnailImageUrl"\s*:\s*"([^"]+)""#
                    let brandName = #""brandName"\s*:\s*"([^"]+)""#
                    let salePrice = #""salePrice"\s*:\s*"?([0-9]+)"?"#
                    let discountRate = #""discountRate"\s*:\s*"?([0-9]+)"?"#
                    
                    if let goodsNm = json.firstMatch(for: goodsNm),
                       let thumbnailImageUrl = json.firstMatch(for: thumbnailImageUrl),
                       let brandName = json.firstMatch(for: brandName),
                       let salePrice = json.firstMatch(for: salePrice),
                       let discountRate = json.firstMatch(for: discountRate) {
                        
                        let metadata = ProductMetadataDTO(
                            platform: 1,
                            productName: goodsNm,
                            brandName: brandName,
                            discountRate: discountRate,
                            price: salePrice,
                            imageURL: "https://image.msscdn.net" + thumbnailImageUrl,
                            productURL: ogUrl,
                            extra: nil
                        )
                        single(.success(metadata))
                    } else {
                        single(.failure(ShareExtensionError.invalidProductData))
                    }
                } else {
                    single(.failure(ShareExtensionError.jsonScriptParsingFailed))
                }
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
