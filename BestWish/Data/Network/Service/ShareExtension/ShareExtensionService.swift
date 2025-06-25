//
//  ShareExtensionService.swift
//  BestWish
//
//  Created by 백래훈 on 6/9/25.
//

import Foundation

import RxSwift

// MARK: - ShareExtensionService
final class ShareExtensionService {
    static let shared = ShareExtensionService()
    
    private init() {}
    
    // MARK: 쇼핑 플랫폼 감지
    private func detectPlatform(from text: String) -> SharePlatform {
        if text.contains("musinsa") {
            return .musinsa
        } else if text.contains("zigzag") {
            return .zigzag
        } else if text.contains("a-bly") {
            return .ably
        }
        return .unknown
    }
    
    // MARK: - 텍스트 내 URL 추출
    static func extractURL(from text: String) -> URL? {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector?.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        return matches?.first?.url
    }

    // MARK: - URL 요청을 통해 리디렉션된 최종 URL 반환 (공통)
    func resolveFinalURL(url: URL) -> Single<URL> {
        return Single<URL>.create { single in
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.timeoutInterval = 10
            request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            let task = URLSession.shared.dataTask(with: request) { _, response, error in
                if let finalURL = response?.url {
                    single(.success(finalURL))
                } else if let error {
                    single(.failure(error))
                } else {
                    single(.failure(ShareExtensionError.redirectionFailed))
                }
            }
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }

    // MARK: - URL 요청을 통해 리디렉션된 최종 URL과 html 반환 (지그재그)
    func resolveZigzagFinalURL(url: URL) -> Single<(URL, String)> {
        return Single<(URL, String)>.create { single in
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.timeoutInterval = 10
            request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            request.setValue(
                "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36",
                forHTTPHeaderField: "User-Agent"
            )
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let finalURL = response?.url,
                   let html = data.flatMap({ String(data: $0, encoding: .utf8) }) {
                    single(.success((finalURL, html)))
                } else if let error = error {
                    single(.failure(error))
                } else {
                    single(.failure(ShareExtensionError.htmlParsingFailed))
                }
            }
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }

    // MARK: - Fetch Platform Metadata
    func fetchPlatformMetadata(from sharedText: String) -> Single<(String, ProductMetadataDTO)> {
        guard let originalUrl = ShareExtensionService.extractURL(from: sharedText) else {
            return Single.error(ShareExtensionError.invaildURL)
        }
        
        let platform = detectPlatform(from: sharedText)
        
        switch platform {
        case .musinsa:
            return resolveFinalURL(url: originalUrl)
                .flatMap { finalURL in
                    MusinsaFetcher().fetchMetadata(ogUrl: originalUrl, extraUrl: finalURL)
                        .map { metadata in (originalUrl.absoluteString, metadata) }
                }
        case .zigzag:
            return resolveZigzagFinalURL(url: originalUrl)
                .flatMap { (finalURL, html) in
                    ZigzagFetcher().fetchMetadata(ogUrl: originalUrl, extraUrl: finalURL, html: html)
                        .map { metadata in (originalUrl.absoluteString, metadata) }
                }
        case .ably:
            return resolveFinalURL(url: originalUrl)
                .flatMap { finalURL in
                    AblyFetcher().fetchMetadata(ogUrl: originalUrl, extraUrl: finalURL)
                        .map { metadata in (originalUrl.absoluteString, metadata) }
                }
        case .unknown:
            return Single.error(ShareExtensionError.platformDetectionFailed)
        }
    }
}
