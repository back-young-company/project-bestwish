//
//  Bundle+Util.swift
//  BestWish
//
//  Created by yimkeul on 6/9/25.
//

import Foundation

extension Bundle {
    /// Info.plist의 CFBundleURLTypes에서 모든 URL 스킴을 배열로 리턴
    var redirectURL: URL? {
        guard
            let urlTypes = infoDictionary?["CFBundleURLTypes"] as? [[String: Any]],
            let firstType = urlTypes.first,
            let schemes = firstType["CFBundleURLSchemes"] as? [String],
            let scheme = schemes.first,
            let callbackName = firstType["CFBundleURLName"] as? String
        else {
            fatalError("⚠️ Info.plist의 CFBundleURLTypes 설정을 확인하세요.")
        }

        return URL(string: "\(scheme)://\(callbackName)")
    }

    var apiKey: String {
        guard let value = infoDictionary?["API_KEY"] as? String else {
            fatalError("❌ Info.plist에 API_KEY가 없습니다.")
        }
        return value
    }

    var supabaseURL: URL {
        guard let value = infoDictionary?["SUPABASE_URL"] as? String,
              let url = URL(string: "https://\(value)") else {
            fatalError("❌ Info.plist에 SUPABASE_URL이 없습니다.")
        }
        return url
    }

    var clientID: String {
        guard let value = infoDictionary?["CLIENT_ID"] as? String else {
            fatalError("❌ Info.plist에 CLIENT_ID가 없습니다.")
        }
        return value
    }
    
    var sharing: String {
        guard let value = infoDictionary?["SHARING_KEY"] as? String else {
            fatalError("❌ Info.plist에 SHARING_KEY가 없습니다.")
        }
        return value
    }
}
