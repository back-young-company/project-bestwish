//
//  Int+Extension.swift
//  BestWish
//
//  Created by Quarang on 6/26/25.
//

import Foundation

extension Int {
    func formattedPrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
