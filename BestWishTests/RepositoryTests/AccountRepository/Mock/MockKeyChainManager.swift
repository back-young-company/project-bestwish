//
//  MockKeyChainManager.swift
//  BestWishTests
//
//  Created by 이수현 on 6/26/25.
//

import Foundation
@testable import BestWish

import Supabase

/// Mock 키체인 매니저
final class MockKeyChainManager: KeyChainManager {
    func saveAllToken(session: Auth.Session) async {
        return
    }
    
    func deleteAllToken() async {
        return
    }
    
    func read(token: BestWish.Token) -> String? {
        nil
    }
}
