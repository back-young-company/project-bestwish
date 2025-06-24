//
//  ProductSyncManager.swift
//  BestWish
//
//  Created by 백래훈 on 6/9/25.
//

import Foundation

import RxSwift

/// 상품 저장을 위한 ProductSyncManager 클래스
final class ProductSyncManager {
    static let shared = ProductSyncManager()
    
    private init() {}

    /// 외부 플랫폼 상품 fetch 시도
    func fetchProductSync(from sharedText: String) async throws -> (String, ProductMetadataDTO) {
        guard let originalUrl = extractURL(from: sharedText) else {
            throw ShareExtensionError.invaildURL
        }
        
        let platform = detectPlatform(from: sharedText)
        
        switch platform {
        case .musinsa:
            let finalURL = try await resolveFinalURL(url: originalUrl)
            let metadata = try await MusinsaFetcher().fetchMetadata(ogUrl: originalUrl, extraUrl: finalURL)
            return (originalUrl.absoluteString, metadata)
        case .zigzag:
            let (finalURL, html) = try await resolveZigzagFinalURL(url: originalUrl)
            let metadata = try await ZigzagFetcher().fetchMetadata(ogUrl: originalUrl, extraUrl: finalURL, html: html)
            return (originalUrl.absoluteString, metadata)
        case .ably:
            let finalURL = try await resolveFinalURL(url: originalUrl)
            let metadata = try await AblyFetcher().fetchMetadata(ogUrl: originalUrl, extraUrl: finalURL)
            return (originalUrl.absoluteString, metadata)
        case .unknown:
            throw ShareExtensionError.platformDetectionFailed
        }
    }
}

// MARK: - private 메서드
private extension ProductSyncManager {
    /// 쇼핑 플랫폼 감지
    func detectPlatform(from text: String) -> SharePlatform {
        if text.contains(SharePlatform.musinsa.rawValue) {
            return .musinsa
        } else if text.contains(SharePlatform.zigzag.rawValue) {
            return .zigzag
        } else if text.contains(SharePlatform.ably.rawValue) {
            return .ably
        }
        return .unknown
    }

    /// 텍스트 내 URL 추출
    func extractURL(from text: String) -> URL? {
        let detector = try? NSDataDetector(
            types: NSTextCheckingResult.CheckingType.link.rawValue
        )
        let matches = detector?.matches(
            in: text,
            options: [],
            range: NSRange(location: 0, length: text.utf16.count)
        )
        return matches?.first?.url
    }

    /// URL 요청을 통해 리디렉션된 최종 URL 반환 (공통)
    func resolveFinalURL(url: URL) async throws -> URL {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData

        let (_, response) = try await URLSession.shared.data(for: request)
        if let finalURL = response.url {
            return finalURL
        } else {
            throw ShareExtensionError.redirectionFailed
        }
    }

    /// URL 요청을 통해 리디렉션된 최종 URL과 html 반환 (지그재그)
    func resolveZigzagFinalURL(url: URL) async throws -> (URL, String) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.setValue(
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36",
            forHTTPHeaderField: "User-Agent"
        )

        let (data, response) = try await URLSession.shared.data(for: request)
        if let finalURL = response.url,
           let html = String(data: data, encoding: .utf8) {
            return (finalURL, html)
        } else {
            throw ShareExtensionError.htmlParsingFailed
        }
    }
}
