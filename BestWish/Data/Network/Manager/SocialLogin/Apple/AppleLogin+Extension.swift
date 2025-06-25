//
//  AppleLogin+Extension.swift
//  BestWish
//
//  Created by yimkeul on 6/9/25.
//

import Foundation
import CryptoKit

extension SupabaseOAuthManager {
    public func generateRandomNonce(length: Int = 32) -> String {
        let characters = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                _ = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                return random
            }
            randoms.forEach { random in
                if remainingLength == 0 { return }
                if random < characters.count {
                    result.append(characters[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }

    public func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}
