//
//  KeyChainManager.swift
//  BestWish
//
//  Created by yimkeul on 6/9/25.
//

import Foundation
import Supabase

actor KeyChainManager {
    // MARK: – 비동기 저장/삭제 (actor 격리 유지)
    func saveAllToken(session: Supabase.Session) async {
        await save(token: Token(service: .access, value: session.accessToken))
        await save(token: Token(service: .refresh, value: session.refreshToken))
    }

    func deleteAllToken() async {
        await delete(token: Token(service: .access))
        await delete(token: Token(service: .refresh))
    }

    private func save(token: Token) async {
        let baseQuery: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: token.service.type,
            kSecAttrAccount: token.account
        ]
        SecItemDelete(baseQuery as CFDictionary)
        guard let data = token.data else { return }
        var addQuery = baseQuery
        addQuery[kSecValueData] = data
        SecItemAdd(addQuery as CFDictionary, nil)
        let eData = String(data: data, encoding: .utf8) ?? ""

        print("키체인 \(token.service.type) - \(eData.prefix(10)) 저장 성공")
    }

    private func delete(token: Token) async {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: token.service.type,
            kSecAttrAccount: token.account
        ]
        SecItemDelete(query as CFDictionary)
        print("키체인 \(token.service.type) 삭제")
    }

    // MARK: – 동기 읽기 (nonisolated)

    nonisolated func read(token: Token) -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: token.service.type,
            kSecAttrAccount: token.account,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess,
            let data = result as? Data,
            let str = String(data: data, encoding: .utf8)
            else {
            return nil
        }
        print("키체인 \(token.service.type) 불러오기 성공")
        return str
    }
}
