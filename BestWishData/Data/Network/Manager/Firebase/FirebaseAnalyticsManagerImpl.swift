//
//  FirebaseAnalyticsManagerImpl.swift
//  BestWishData
//
//  Created by yimkeul on 7/3/25.
//

import BestWishDomain
import Foundation
import FirebaseCore
internal import FirebaseAnalytics


public final class FirebaseAnalyticsManagerImpl: FirebaseAnalyticsManager {

    public init() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }

    public func logEvent(_ name: String, parameters: [String : Any]?) {
        Analytics.logEvent(name, parameters: parameters)
    }

    public func logProductSync(parameters: [String : Any]?) {
        Analytics.logEvent("ProductSyncFailed", parameters: parameters)
    }
}
