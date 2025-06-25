//
//  Platform+Util.swift
//  BestWish
//
//  Created by 백래훈 on 6/25/25.
//

import Foundation

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
        default: return "unknown"
        }
    }
}
