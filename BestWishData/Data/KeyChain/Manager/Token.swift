//
//  Token.swift
//  BestWish
//
//  Created by yimkeul on 6/9/25.
//

import Foundation

public struct Token {
    let service: TokenType
    let value: String?
    let account: String = "current_user"
    let sharing: String = Bundle.main.sharing

    var data: Data? {
        if let value {
            return value.data(using: .utf8)
        }
        return nil
    }

    public init(service: TokenType, value: String? = nil) {
        self.service = service
        self.value = value
    }
}


public enum TokenType {
    case access // Supabase access token
    case refresh // Supabase refresh token

    var type: String {
        switch self {
        case .access: return "SupabaseAccessToken"
        case .refresh: return "SupabaseRefreshToken"
        }
    }
}
