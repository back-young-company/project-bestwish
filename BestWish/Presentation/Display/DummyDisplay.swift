//
//  DummyDisplay.swift
//  BestWish
//
//  Created by 이수현 on 6/4/25.
//

import Foundation

struct DummyDisplay {
    let title: String
    let price: String
}

extension DummyDisplay {
    static func convertToDisplay(from model: Dummy) -> DummyDisplay {
        let price = "\(Int(model.price).formatted(.currency(code: "KRW")))원"
        return DummyDisplay(title: model.title, price: price)
    }
}
