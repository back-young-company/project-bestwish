//
//  Bundle+Extension.swift
//  BestWish
//
//  Created by yimkeul on 6/9/25.
//

import Foundation

extension Bundle {
    /// Info.plist의 CFBundleURLTypes에서 모든 URL 스킴을 배열로 리턴
    var urlSchemes: [String] {
        guard
            let urlTypes = infoDictionary?["CFBundleURLTypes"] as? [[String: Any]]
        else { return [] }

        return urlTypes
            .compactMap { $0["CFBundleURLSchemes"] as? [String] }
            .flatMap { $0 }
    }
}
