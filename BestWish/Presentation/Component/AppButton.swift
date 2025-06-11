//
//  AppButton.swift
//  BestWish
//
//  Created by 이수현 on 6/9/25.
//

import UIKit
/// 커스텀 버튼 클래스
///
/// ```swift
/// private let button = AppButton(type: .analyze)
/// ```
final class AppButton: UIButton {
    private let type: ButtonType
    private let fontSize: CGFloat

    init(type: ButtonType, fontSize: CGFloat = 18) {
        self.type = type
        self.fontSize = fontSize

        super.init(frame: .zero)
        setView()
    }
    
    required
    init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AppButton {
    func setView() {
        setAttributes()
    }

    func setAttributes() {
        self.setTitle(type.title, for: .normal)
        self.setTitleColor(type.titleColor, for: .normal)
        self.titleLabel?.font = .font(.pretendardBold, ofSize: fontSize)
        self.backgroundColor = type.backgroundColor
        self.layer.cornerRadius = 12
        self.layer.borderWidth = type.borderWidth
        self.layer.borderColor = type.borderColor?.cgColor
    }
}

//MARK: 버튼 타입

extension AppButton {
    enum ButtonType {
        case complete
        case next
        case shortcut
        case analyze
        case viewProduct
        case confirmChange
        case save
        case back
        case reset
        case cancel
        case before
    }
}

extension AppButton.ButtonType {
    var title: String {
        switch self {
        case .complete: "완료"
        case .next: "다음"
        case .shortcut: "바로가기"
        case .analyze: "분석하기"
        case .viewProduct: "상품 보기"
        case .confirmChange: "변경 완료"
        case .save: "저장"
        case .back: "뒤로"
        case .reset: "초기화"
        case .cancel: "취소"
        case .before: "이전"
        }
    }

    var titleColor: UIColor? {
        switch self {
        case .complete, .next, .shortcut, .analyze,
                .viewProduct, .confirmChange, .save:
            return .gray0
        case .back, .reset, .cancel:
            return .gray200
        case .before:
            return .gray300
        }
    }

    var backgroundColor: UIColor? {
        switch self {
        case .complete, .next, .shortcut, .analyze,
                .viewProduct, .confirmChange, .save:
            return .primary300
        case .back, .reset:
            return .gray600
        case .cancel, .before:
            return .gray0
        }
    }

    var borderColor: UIColor? {
        switch self {
        case .cancel, .before:
            return .gray100
        default:
            return nil
        }
    }

    var borderWidth: CGFloat {
        switch self {
        case .cancel, .before:
            return 1.5
        default:
            return 0
        }
    }
}
