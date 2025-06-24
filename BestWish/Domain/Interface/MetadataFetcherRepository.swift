//
//  MetadataFetcherRepository.swift
//  BestWish
//
//  Created by 백래훈 on 6/9/25.
//

import Foundation

import RxSwift

// MARK: - Metadata Fetcher Protocol
protocol ShareMetadataFetcher {
    func fetchMetadata(ogUrl: URL, extraUrl: URL) async throws -> ProductMetadataDTO
}

protocol HTMLBasedMetadataFetcher {
    func fetchMetadata(ogUrl: URL, extraUrl: URL, html: String) async throws -> ProductMetadataDTO
}
