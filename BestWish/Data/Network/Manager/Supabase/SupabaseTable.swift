//
//  SupabaseTable.swift
//  BestWish
//
//  Created by 이수현 on 6/5/25.
//

import Foundation

enum SupabaseTable: String {
    case product = "Product"
    case userInfo = "UserInfo"
}

enum ProductAttributes: String {
    case id
    case created_at
    case user_id
    case platform
    case title
    case price
    case discount_rate
    case brand
    case image_path_url
    case product_url
}

enum UserInfoAttributes: String {
    case id
    case created_at
    case email
    case name
    case gender
    case birth
    case profile_image_code
    case role
    case platform_sequence
    case auth_provider
    case nickname
}
