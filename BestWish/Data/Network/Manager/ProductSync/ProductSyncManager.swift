//
//  ProductSyncManager.swift
//  BestWish
//
//  Created by 백래훈 on 6/9/25.
//

import Foundation

/// 상품 저장을 위한 ProductSyncManager 클래스
final class ProductSyncManager {
    /// 외부 플랫폼 상품 fetch 시도
    func fetchProductSync(from sharedText: String) async throws -> ProductDTO {
        guard let originalUrl = try extractURL(from: sharedText) else {
            throw ProductSyncError.invaildURL
        }
        
        let platform = detectPlatform(from: sharedText)
        let (finalURL, html) = try await resolveFinalURL(type: platform, url: originalUrl)
        
        guard let metaData = try await platform?.fetcher?.fetchProductDTO(ogUrl: originalUrl, finalUrl: finalURL, html: html) else {
            throw ProductSyncError.platformDetectionFailed
        }
        return metaData
    }
}

// MARK: - private 메서드
private extension ProductSyncManager {
    /// 쇼핑 플랫폼 감지
    func detectPlatform(from text: String) -> PlatformEntity? {
        return PlatformEntity(text: text)
    }

    /// 공유 링크 내 불필요한 텍스트를 제외한 순수 상품 URL 추출
    func extractURL(from text: String) throws -> URL? {
        do {
            let detector = try NSDataDetector(
                types: NSTextCheckingResult.CheckingType.link.rawValue
            )
            let matches = detector.matches(
                in: text,
                options: [],
                range: NSRange(location: 0, length: text.utf16.count)
            )
            return matches.first?.url
        } catch {
            throw ProductSyncError.urlExtractionFailed
        }
    }

    /// URL 요청을 통해 리디렉션된 최종 URL 반환 (공통)
    func resolveFinalURL(type: PlatformEntity? = nil, url: URL) async throws -> (URL, String) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        if type == .zigzag {
            request.setValue(
                "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36",
                forHTTPHeaderField: "User-Agent"
            )
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let finalURL = response.url,
               let html = String(data: data, encoding: .utf8) {
                return (finalURL, html)
            } else {
                throw ProductSyncError.redirectionFailed
            }
        } catch {
            throw ProductSyncError.redirectionFailed
        }
    }
}
