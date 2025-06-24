//
//  MetadataFetcherRepository.swift
//  BestWish
//
//  Created by 백래훈 on 6/9/25.
//

import Foundation

import RxSwift

// MARK: - Metadata Fetcher Protocol
protocol ProductDTOFetcher {
    func fetchProductDTO(ogUrl: URL, extraUrl: URL) async throws -> ProductDTO
}

protocol HTMLProductDTOFetcher {
    func fetchProductDTO(ogUrl: URL, extraUrl: URL, html: String) async throws -> ProductDTO
}
