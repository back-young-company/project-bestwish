//
//  Platform+Util.swift
//  BestWish
//
//  Created by 백래훈 on 6/25/25.
//

import Foundation

// MARK: - Data 레이어에서 사용하기 위한 Extension
extension PlatformEntity {
    init?(text: String) {
        guard let matchedCase = Self.allCases.first(where: { text.contains($0.title) }) else { return nil }
        self = matchedCase
    }

    var title: String {
        switch self {
        case .musinsa: return "musinsa"
        case .zigzag: return "zigzag"
        case .ably: return "a-bly"
        case .kream: return "kream"
        case .brandy: return "brandi"
        case .fnoz: return "4910"
        case .tncm: return "29cm"
        case .hiver: return "hiver"
        default: return "unknown"
        }
    }
    
    var fetcher: ProductDTORepository? {
        switch self {
        case .musinsa: return MusinsaFetcher()
        case .ably: return AblyFetcher()
        case .zigzag: return ZigzagFetcher()
        case .kream: return KreamFetcher()
        case .brandy: return BrandiFetcher()
        case .fnoz: return FNOZFetcher()
        case .tncm: return TNCMFetcher()
        case .hiver: return HiverFetcher()
        default: return nil
        }
    }
}
