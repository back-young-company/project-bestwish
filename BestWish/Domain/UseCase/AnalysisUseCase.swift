//
//  PlatformSearchUseCase.swift
//  BestWish
//
//  Created by Quarang on 6/17/25.
//

/// 이미지 분석 유즈 케이스
protocol AnalysisUseCase {
    /// 키워드 추가 이벤트
    func addKeyword(_ keyword: String, keywords: inout [String]) -> [String]
    /// 키워드 삭제 이벤트
    func deleteKeyword(_ keyword: String, keywords: inout [String]) -> [String]
    /// 플랫폼 이동
    func movePlatform(deepLink: String?) throws -> String
}

/// 이미지 분석 유즈 케이스 구현체
final class AnalysisUseCaseImpl: AnalysisUseCase {
    
    /// 키워드 추가 이벤트
    func addKeyword(_ keyword: String, keywords: inout [String]) -> [String] {
        if !keywords.contains(keyword) {
            keywords.append(keyword)
        }
        return keywords
    }
    
    /// 키워드 삭제 이벤트
    func deleteKeyword(_ keyword: String, keywords: inout [String]) -> [String] {
        keywords.removeAll(where: { $0 == keyword })
        return keywords
    }
    
    /// 플랫폼 이동
    func movePlatform(deepLink: String?) throws -> String {
        guard let deepLink else {
            throw PlatformError.notFoundDeepLink
        }
        if deepLink != "notFound" {
            return deepLink
        } else {
            throw PlatformError.preparePlatform
        }
    }
}
