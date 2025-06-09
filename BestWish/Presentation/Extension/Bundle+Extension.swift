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

    var redirectURL: URL? {
        guard
            let urlTypes = infoDictionary?["CFBundleURLTypes"] as? [[String: Any]],
            let firstType = urlTypes.first,
            let schemes = firstType["CFBundleURLSchemes"] as? [String],
            let scheme = schemes.first,
            let callbackName = firstType["CFBundleURLName"] as? String
        else {
            print("⚠️ Info.plist의 CFBundleURLTypes 설정을 확인하세요.")
            return nil
        }

        return URL(string: "\(scheme)://\(callbackName)")
    }

    var apiKey: String {
        guard let value = infoDictionary?["API_KEY"] as? String else {
            fatalError("❌ Info.plist에 API_KEY가 없습니다.")
        }
        return value
    }

    var supabaseURL: String {
        guard let value = infoDictionary?["SUPABASE_URL"] as? String else {
            fatalError("❌ Info.plist에 SUPABASE_URL이 없습니다.")
        }
        return value
    }
}
