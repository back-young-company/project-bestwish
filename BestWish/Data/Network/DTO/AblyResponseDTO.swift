//
//  AblyResponseDTO.swift
//  BestWish
//
//  Created by 백래훈 on 6/9/25.
//

import Foundation

struct AblyResponseDTO: Codable {
    let props: Props
}

struct Props: Codable {
    let pageProps: PageProps
    let serverQueryClient: ServerQueryClient
}

struct PageProps: Codable {
//    let serverQueryClient: ServerQueryClient
}

struct ServerQueryClient: Codable {
    let queries: [Query]
}

struct Query: Codable {
    let state: State2
}

struct State2: Codable {
    let data: GoodsData
}

struct GoodsData: Codable {
    let goods: Goods
}

struct Goods: Codable {
    let name: String?
    let priceInfo: PriceInfo
    let market: Market
    let coverImages: [String]
    
    enum CodingKeys: String, CodingKey {
        case name, market
        case priceInfo = "price_info"
        case coverImages = "cover_images"
    }
}

struct PriceInfo: Codable {
    let consumer: Int?
    let thumbnailPrice: Int?
    let discountRate: Int?
    
    enum CodingKeys: String, CodingKey {
        case consumer
        case thumbnailPrice = "thumbnail_price"
        case discountRate = "discount_rate"
    }
}

struct Market: Codable {
    let name: String?
    let image: String?
}
