//
//  SupabaseActor.swift
//  BestWishData
//
//  Created by 이수현 on 9/23/25.
//

import Foundation

internal import Supabase

/// 동시성 환경에서 SupabaseClient에 접근을 안전하게 보장하기 위한 actor
public actor SupabaseActor {
    let client: SupabaseClient

    public init() {
        self.client = SupabaseClient(
            supabaseURL: Bundle.main.supabaseURL,
            supabaseKey: Bundle.main.apiKey
        )
    }
}
