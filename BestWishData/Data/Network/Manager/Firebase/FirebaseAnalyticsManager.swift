//
//  FirebaseAnalyticsManager.swift
//  BestWishData
//
//  Created by yimkeul on 7/3/25.
//

import Foundation
import BestWishDomain

public protocol FirebaseAnalyticsManager {
    func logEvent(_ name: String, parameters: [String: Any]?)
}
