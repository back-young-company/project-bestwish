//
//  HiverFetcher.swift
//  BestWish
//
//  Created by Quarang on 6/29/25.
//

import Foundation

import SwiftSoup

/// Hiver 페쳐
final class HiverFetcher: ProductDTORepository {
    
    /// 하이버 제품 상세 HTML → ProductDTO 파싱
    func fetchProductDTO(ogUrl: URL?, finalUrl: URL?, html: String?) async throws -> ProductDTO {
        let html = html ?? ""
        let doc = try SwiftSoup.parse(html)

        let title = try doc.title()
        let imageURL = try doc.select("meta[property=og:image]").attr("content")

        let price = extractValue(html, pattern: #""sale_price"\s*:\s*(\d+)"#, transform: { Int($0) })
        let discount = extractValue(html, pattern: #""original_sale_percent"\s*:\s*(\d+)"#, transform: { $0 })
        let sellerName = extractValue(html, pattern: #""seller"\s*:\s*\{[^}]*?"name"\s*:\s*"([^"]+)""#, transform: { $0 })
        
        print( ProductDTO(
            id: nil,
            userID: nil,
            platform: 11,
            title: title,
            price: price,
            discountRate: discount,
            brand: sellerName,
            imagePathURL: imageURL,
            productURL: convertToProductURL(from: ogUrl?.absoluteString),
            createdAt: nil
        ))
        
        throw ProductSyncError.dataLoadingFailed
    }
    
    /// 원링크 -> 사이트 링크 (제대로된 파싱을 위함)
    private func convertToProductURL(from originalURL: String?) -> String? {
        guard let url = URLComponents(string: originalURL ?? ""),
              let queryItems = url.queryItems,
              let id = queryItems.first(where: { $0.name == "id" })?.value else {
            return nil
        }
        return "https://www.hiver.co.kr/products/\(id)"
    }
    
    /// 정해진 패턴으로 데이터를 추출하는 메서드
    private func extractValue<T>(_ html: String, pattern: String, transform: (String) -> T?) -> T? {
        if let regex = try? NSRegularExpression(pattern: pattern),
           let match = regex.firstMatch(in: html, range: NSRange(html.startIndex..., in: html)),
           let range = Range(match.range(at: 1), in: html) {
            return transform(String(html[range]))
        }
        return nil
    }
}

// 앱에서 가져온 상품 링크
// https://www.hiver.co.kr/onelink?type=products&id=178554124&shareType=share_pdp_url&deep_link_value=hiverapplication://applink/products/178554124

// 사이트에서 가져온 상품 링크
// https://www.hiver.co.kr/onelink?type=products&id=178554124&shareType=share_pdp_url&deep_link_value=hiverapplication://applink/products/178554124

// 실제 사이트
// https://www.hiver.co.kr/products/178554124

