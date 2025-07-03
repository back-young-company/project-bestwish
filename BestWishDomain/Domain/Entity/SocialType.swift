//
//  SocialType.swift
//  BestWish
//
//  Created by yimkeul on 6/23/25.
//

import Foundation

/// 소셜로그인 타입
public enum SocialType {
    case kakao
    case apple

    public init?(provider: String?) {
        switch provider {
        case "kakao": self = .kakao
        case "apple": self = .apple
        default: return nil
        }
    }

    public var korean: String {
        switch self {
        case .kakao: "카카오"
        case .apple: "애플"
        }
    }
}
