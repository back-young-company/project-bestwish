//
//  KeyChainManager.swift
//  BestWish
//
//  Created by yimkeul on 6/9/25.
//

import Foundation
import Supabase

final class KeyChainManager {
    static let shared = KeyChainManager()
    private init() {}

    func saveAllToken(session: Supabase.Session) {
        save(token: Token(service: .access, value: session.accessToken))
        save(token: Token(service: .refresh, value: session.refreshToken))
    }

    func deleteAllToken() {
        delete(token: Token(service: .access))
        delete(token: Token(service: .refresh))
    }

    func read(token: Token) -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: token.service.type,
            kSecAttrAccount: token.account,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess else { return nil }

        // 1) AnyObject → Data
        guard let data = result as? Data else {
            print("키체인 결과를 Data로 변환할 수 없음")
            return nil
        }

        // 2) Data → String
        guard let string = String(data: data, encoding: .utf8) else {
            print("Data를 UTF-8 String으로 디코딩 실패")
            return nil
        }

        print("키체인 \(token.service.type) 불러오기 성공")
        return string
    }

    private func save(token: Token) {
        delete(token: token)
        guard let data = token.data else { return }
        let attributes: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: token.service.type,
            kSecAttrAccount: token.account,
            kSecValueData: data
        ]
        SecItemAdd(attributes as CFDictionary, nil)

        let eData = String(data: data, encoding: .utf8) ?? ""

        print("키체인 \(token.service.type) - \(eData.prefix(10)) 저장 성공")
    }



    private func delete(token: Token) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: token.service.type,
            kSecAttrAccount: token.account
        ]
        SecItemDelete(query as CFDictionary)

        print("키체인 \(token.service.type) 삭제")
    }


}
