//
//  MappingError.swift
//  BestWish
//
//  Created by 이수현 on 6/16/25.
//

import Foundation

enum MappingError: AppErrorProtocol {
    case productDTOToProduct
    case userDTOToUser
}

extension MappingError {
    var errorDescription: String? {
        switch self {
        case .productDTOToProduct, .userDTOToUser:
            "데이터를 불러오는 중 에러가 발생했습니다."
        }
    }

    var debugDescription: String {
        switch self {
        case .productDTOToProduct:
            "productDTOToProduct Error"
        case .userDTOToUser:
            "userDTOToUser Error"
        }
    }
}
