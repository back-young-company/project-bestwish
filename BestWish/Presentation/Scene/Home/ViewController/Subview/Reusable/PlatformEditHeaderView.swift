//
//  PlatformEditHeaderView.swift
//  BestWish
//
//  Created by 백래훈 on 6/12/25.
//

import UIKit

import SnapKit
import Then

/// 플랫폼 편집 Header View
final class PlatformEditHeaderView: UIView {

    // MARK: - Private Property
    private let _platformCountLabel = UILabel()
    private let _completeButton = UIButton()
    
    // MARK: - Internal Property
    var completeButton: UIButton { _completeButton }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(count: Int) {
        _platformCountLabel.text = "플랫폼 \(count)개"
    }
}

// MARK: - PlatformEditHeaderView 설정
private extension PlatformEditHeaderView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }
    
    func setAttributes() {
        _platformCountLabel.do {
            $0.textColor = .gray200
            $0.font = .font(.pretendardMedium, ofSize: 12)
        }
        
        _completeButton.do {
            let titleFont = UIFont.font(.pretendardBold, ofSize: 12)
            var config = UIButton.Configuration.filled()
            config.cornerStyle = .capsule
            config.baseForegroundColor = .white
            config.baseBackgroundColor = .primary300
            config.attributedTitle = AttributedString("완료", attributes: AttributeContainer([.font: titleFont]))
            $0.configuration = config
        }
    }
    
    func setHierarchy() {
        self.addSubviews(_platformCountLabel, _completeButton)
    }
    
    func setConstraints() {
        _platformCountLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().offset(20)
        }
        
        _completeButton.snp.makeConstraints {
            $0.centerY.equalTo(_platformCountLabel)
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.equalTo(48)
            $0.height.equalTo(26)
        }
    }
}
