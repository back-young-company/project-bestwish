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
    func fetchMetadata(from url: URL) -> Single<ProductMetadataDTO>
}

protocol HTMLBasedMetadataFetcher {
    func fetchMetadata(from url: URL, html: String) -> Single<ProductMetadataDTO>
}
