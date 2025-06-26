//
//  PlatformSearchUseCase.swift
//  BestWish
//
//  Created by Quarang on 6/17/25.
//

/// 이미지 분석 유즈 케이스
protocol AnalysisUseCase {
    /// 키워드 추가 이벤트
    func addKeyword(_ keyword: String, keywords: inout [String])
    /// 키워드 삭제 이벤트
    func deleteKeyword(_ keyword: String, keywords: inout [String])
    /// 키워드 초기화 이벤트
    func resetKeyword(keywords: inout [String])
    /// 플랫폼 이동
    func movePlatform(deepLink: String?) throws -> String
}

/// 이미지 분석 유즈 케이스 구현체
final class AnalysisUseCaseImpl: AnalysisUseCase {
    
    /// 키워드 추가 이벤트
    func addKeyword(_ keyword: String, keywords: inout [String]) {
        if !keywords.contains(keyword) {
            keywords.append(keyword)
        }
    }
    
    /// 키워드 삭제 이벤트
    func deleteKeyword(_ keyword: String, keywords: inout [String]) {
        keywords.removeAll(where: { $0 == keyword })
    }
    
    /// 키워드 초기화 이벤트
    func resetKeyword(keywords: inout [String]) {
        keywords.removeAll()
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
