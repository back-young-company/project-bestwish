//
//  String+Extension.swift
//  BestWish
//
//  Created by 백래훈 on 6/9/25.
//

import Foundation

// MARK: - HTML 코드에서 사용되는 메서드
extension String {
    
    /// 정해진 패턴으로 데이터를 추출하는 메서드
    func htmlExtractValue<T>(pattern: String, transform: (String) -> T?) -> T? {
        if let regex = try? NSRegularExpression(pattern: pattern),
           let match = regex.firstMatch(in: self, range: NSRange(self.startIndex..., in: self)),
           let range = Range(match.range(at: 1), in: self) {
            return transform(String(self[range]))
        }
        return nil
    }
    
    /// 정규식 범위로 자르고 해당 범위 내 모든 숫자를 Int 배열로 추출
    func extractNumbers(inRangeMatching rangePattern: String) -> [Int]? {
        guard let range = self.range(of: rangePattern, options: .regularExpression) else {
            return nil
        }

        let result = String(self[range])

        let regex = try? NSRegularExpression(pattern: "\\d+", options: [])
        let matches = regex?.matches(in: result, options: [], range: NSRange(result.startIndex..., in: result))

        return matches?.compactMap { match in
            guard let numberRange = Range(match.range, in: result) else { return nil }
            return Int(result[numberRange])
        }
    }
    
    /// 딥링크 → 사이트 링크 (상품 페이지 URL 추출)
    func convertDeepLinkToProductURL(_ type: PlatformEntity) -> String {
        guard let url = URLComponents(string: self),
              let queryItems = url.queryItems,
              let id = queryItems.first(where: { $0.name == "id" })?.value else {
            return self
        }
        
        switch type {
        case .kream:
            return "kreamapp://shop/product?id=" + id
        case .brandy:
            return "https://www.brandi.co.kr/products/" + id
        case .hiver:
            return "https://www.hiver.co.kr/products/" + id
        default:
            return self
        }
    }
    
    /// 사이트링크 -> 딥 링크 (상품 바로가기 링크 추출을 위함)
    func convertProductURLToDeepLink(_ type: PlatformEntity) -> String {
        switch type {
        case .zigzag:
            let domain = "https://zigzag.kr/p/"
            guard self.contains(domain) else { return self }
            let productId = self.replacingOccurrences(of: domain, with: "")
            return "zigzag:///product_detail?browsing_type=INTERNAL_BROWSER\\u0026catalog_product_id=\(productId)\\u0026url=https://store.zigzag.kr/app/catalog/products/\(productId)?catalog_product_id=\(productId)\\u0026shop_id=795\\u0026uau=bdeb5ae3-0a5c-4f58-a7aa-094f7f72f21f\\u0026catalog_product_id=\(productId)"
        case .brandy:
            let domain = "https://www.brandi.co.kr/products/"
            guard self.contains(domain) else { return self }
            let productId = self.replacingOccurrences(of: domain, with: "")
            return "https://www.brandi.co.kr/onelink?type=products&id=\(productId)&shareType=share_pdp_url"
        case .fnoz:
            let domain = "https://4910.kr/goods/"
            guard self.contains(domain) else { return self }
            let productId = self.replacingOccurrences(of: domain, with: "")
            return "aglo://webview?url=https://4910.kr/goods/\(productId)"
        case .hiver:
            let domain = "https://www.hiver.co.kr/products/"
            guard self.contains(domain) else { return self }
            let productId = self.replacingOccurrences(of: domain, with: "")
            return "https://www.hiver.co.kr/onelink?type=products&id=\(productId)&shareType=share_pdp_url&deep_link_value=hiverapplication://applink/products/\(productId)"
        default: return self
        }
    }
}


// MARK: 무신사
// 앱을 통해 복사한 링크
// https://musinsa.onelink.me/PvkC/281mrhzm
// 상품 사이트 링크
// https://www.musinsa.com/products/4108095

// MARK: 에이블리
// 앱을 통해 복사한 링크
// https://applink.a-bly.com/wooa9r
// 상품 사이트 링크
// https://m.a-bly.com/goods/2647293

// MARK: 지그재그
// 앱을 통해 복사한 링크
// zigzag:///product_detail?browsing_type=INTERNAL_BROWSER\\u0026catalog_product_id=161021799\\u0026url=https://store.zigzag.kr/app/catalog/products/161021799?catalog_product_id=161021799\\u0026shop_id=795\\u0026uau=bdeb5ae3-0a5c-4f58-a7aa-094f7f72f21f\\u0026catalog_product_id=161021799
// 상품 사이트 링크
// https://zigzag.kr/p/161021799

// MARK: 크림
// 앱을 통해 복사한 링크
// https://kream.co.kr/products/542052
// 상품 사이트 링크
// https://kream.co.kr/products/542052 , kreamapp://shop/product?id=542052

// MARK: - 브랜디 (사이트 링크 -> 딥 링크 필요)
// 앱을 통해 복사한 링크
// https://www.brandi.co.kr/onelink?type=products&id=136942411&shareType=share_pdp_url
// 상품 사이트 링크
// https://www.brandi.co.kr/products/136942411

// MARK: - 29CM (html안에 딥링크가 있음)
// 앱을 통해 복사한 링크
// https://29cm.onelink.me/1080201211/nb28cm0h
// 상품 사이트 링크
// https://www.29cm.co.kr/products/3191704

// MARK: - 4910 (사이트 링크 -> 딥 링크 필요)
// 앱을 통해 복사한 링크:
// https://4910.kr/goods/47049173 , aglo://webview?url=https://4910.kr/goods/47049173
// 상품 사이트 링크:
// https://4910.kr/goods/47049173

// MARK: - hiver (사이트 링크 -> 딥 링크 필요)
// 앱을 통해 복사한 링크:
// https://www.hiver.co.kr/onelink?type=products&id=178554124&shareType=share_pdp_url&deep_link_value=hiverapplication://applink/products/178554124
// 상품 사이트 링크:
// https://www.hiver.co.kr/products/178554124
