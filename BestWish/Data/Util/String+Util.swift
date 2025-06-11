//
//  String+Extension.swift
//  BestWish
//
//  Created by 백래훈 on 6/9/25.
//

import Foundation

extension String {
    // ✂️ 문자열에서 시작 문자열과 종료 문자열 사이의 내용을 추출
    func slice(from: String, to: String) -> String? {
        guard let fromRange = range(of: from)?.upperBound else { return nil }
        guard let toRange = range(of: to, range: fromRange..<endIndex)?.lowerBound else { return nil }
        return String(self[fromRange..<toRange])
    }
    
    // 🔍 정규식을 사용하여 첫 번째 일치 문자열을 추출
    func firstMatch(for regex: String) -> String? {
        guard let regex = try? NSRegularExpression(pattern: regex, options: .caseInsensitive) else { return nil }
        let range = NSRange(location: 0, length: self.utf16.count)
        if let match = regex.firstMatch(in: self, options: [], range: range),
           let matchRange = Range(match.range(at: 1), in: self) {
            return String(self[matchRange])
        }
        return nil
    }
    
    func extractNEXTDataJSON() -> String? {
        guard let startRange = self.range(of: #"<script id="__NEXT_DATA__" type="application/json">"#),
              let endRange = self.range(of: "</script>", range: startRange.upperBound..<self.endIndex) else {
            return nil
        }
        let jsonString = self[startRange.upperBound..<endRange.lowerBound]
        return String(jsonString)
    }
    
    func extractapplicationLdJson() -> String? {
        guard let startRange = self.range(of: #"<script id="__NEXT_DATA__" type="application/json">"#),
              let endRange = self.range(of: "</script>", range: startRange.upperBound..<self.endIndex) else {
            return nil
        }
        let jsonString = self[startRange.upperBound..<endRange.lowerBound]
        return String(jsonString)
    }
}
