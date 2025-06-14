//
//  EmailConstants.swift
//  BestWish
//
//  Created by 이수현 on 6/14/25.
//

import UIKit

enum EmailConstants {
    case recipients // 수신자
    case subject    // 제목
    case body       // 본문

    case mailUnavailableAlertTitle      // 메일 계정 설정 에러 타이틀
    case mailUnavailableAlertMessage    // 메일 계정 설정 에러 메시지
}

extension EmailConstants {
    var value: String {
        switch self {
        case .recipients:
            "bycompany02@gmail.com"
        case .subject:
            "[문의하기] [제목]"
        case .body:
            """
            안녕하세요, 아래에 문의하실 내용을 작성해주세요.
            
            --------------------
            앱 버전: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "알 수 없음")
            iOS 버전: \(UIDevice.current.systemVersion)
            디바이스: \(UIDevice.current.model)
            --------------------
            """
        case .mailUnavailableAlertTitle:
            "메일 계정을 찾을 수 없습니다."
        case .mailUnavailableAlertMessage:
            """
            문의 메일을 보내기 위해 
            이메일 계정이 필요합니다.

            설정 > 메일에서 계정을 추가하거나,
            \(EmailConstants.recipients.value)로 
            직접 문의해 주세요.
            """
        }
    }
}
