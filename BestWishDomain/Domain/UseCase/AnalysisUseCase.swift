//
//  PlatformSearchUseCase.swift
//  BestWish
//
//  Created by Quarang on 6/17/25.
//

/// 이미지 분석 유즈 케이스
public protocol AnalysisUseCase {
    /// 키워드 추가 이벤트
    func addKeyword(_ keyword: String, keywords: [String]) -> [String]
    /// 키워드 삭제 이벤트
    func deleteKeyword(_ keyword: String, keywords: [String]) -> [String]
    /// 플랫폼 선택 이벤트
    func selectePlatform(platform: PlatformEntity, platforms: [PlatformEntity]) throws -> [(PlatformEntity, Bool)]
    /// 키워드 초기화 이벤트
    func resetKeyword(keywords: [String]) -> [String]
    /// 플랫폼 이동
    func movePlatform(deepLink: String?) throws -> String
}

/// 이미지 분석 유즈 케이스 구현체
public final class AnalysisUseCaseImpl: AnalysisUseCase {

    public init() {}

    /// 키워드 추가 이벤트
    public func addKeyword(_ keyword: String, keywords: [String]) -> [String] {
        var keywords = keywords
        if !keywords.contains(keyword) {
            keywords.append(keyword)
        }
        return keywords
    }
    
    /// 키워드 삭제 이벤트
    public func deleteKeyword(_ keyword: String, keywords: [String]) -> [String] {
        var keywords = keywords
        keywords.removeAll(where: { $0 == keyword })
        return keywords
    }
    
    /// 키워드 초기화 이벤트
    public func resetKeyword(keywords: [String]) -> [String] {
        var keywords = keywords
        keywords.removeAll()
        return keywords
    }
    
    /// 플랫폼 초기화 이벤트
    public func selectePlatform(platform: PlatformEntity, platforms: [PlatformEntity]) throws -> [(PlatformEntity, Bool)] {
        var platforms = platforms.map { (platform: $0, isSelected: false) }
        guard let index = platforms.firstIndex(where: { $0.platform == platform }) else { throw PlatformError.platformNotFound }
        platforms[index].isSelected = true
        return platforms
    }
    
    /// 플랫폼 이동
    public func movePlatform(deepLink: String?) throws -> String {
        guard let deepLink else {
            throw PlatformError.deepLinknotFound
        }
        if deepLink != "notFound" {
            return deepLink
        } else {
            throw PlatformError.preparePlatform
        }
    }
}
