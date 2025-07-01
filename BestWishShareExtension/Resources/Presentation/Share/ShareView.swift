//
//  ShareView.swift
//  BestWishShareExtension
//
//  Created by 백래훈 on 6/14/25.
//

import UIKit

internal import SnapKit
internal import Then

/// 공유 View
final class ShareView: UIView {

    // MARK: - Private Property
    private let _backgroundView = UIView()
    private let _contentView = UIView()
    private let _grabBar = UIView()
    private let _completeImage = UIImageView()
    private let _completeLabel = UILabel()
    private let _descriptionLabel = UILabel()
    private let _shortcutButton = UIButton()

    // MARK: - Internal Property
    var backgroundView: UIView { _backgroundView }
    var shortcutButton: UIButton { _shortcutButton }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - ShareView 설정
private extension ShareView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {

        _backgroundView.do {
            // .clear로 하면 터치 이벤트 반응 안 함
            $0.backgroundColor = .black.withAlphaComponent(0.001)
            $0.isUserInteractionEnabled = true
        }

        _contentView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 15
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.isUserInteractionEnabled = true
        }

        _grabBar.do {
            $0.backgroundColor = .gray100
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 3
        }
        
        _completeImage.do {
            $0.image = UIImage(systemName: "paperplane.fill")
            $0.tintColor = .primary200
            $0.contentMode = .scaleAspectFit
        }
        
        _completeLabel.do {
            $0.text = "저장 중..."
            $0.font = .font(.pretendardBold, ofSize: 18)
            $0.textColor = .gray900
        }
        
        _descriptionLabel.do {
            $0.text = "저장이 완료되면 앱으로 다시 돌아가 주세요."
            $0.font = .font(.pretendardMedium, ofSize: 16)
            $0.textColor = .gray500
        }
        
        _shortcutButton.do {
            var config = UIButton.Configuration.plain()
            let titleFont = UIFont.font(.pretendardBold, ofSize: 16)
            config.attributedTitle = AttributedString("베스트위시 바로가기", attributes: AttributeContainer([.font: titleFont]))
            config.baseForegroundColor = .primary200
            $0.configuration = config

            let handler: UIButton.ConfigurationUpdateHandler = { button in
                switch button.state {
                case .highlighted:
                    button.backgroundColor = .primary50
                case .disabled:
                    button.backgroundColor = .gray50
                    button.layer.borderWidth = 0
                default:
                    button.backgroundColor = .gray0
                    button.layer.borderWidth = 1.5
                }
            }
            $0.configurationUpdateHandler = handler

            $0.layer.borderColor = UIColor.primary200?.cgColor
            $0.layer.cornerRadius = 10
            $0.layer.borderWidth = 1.5
            $0.clipsToBounds = true
            $0.isEnabled = false
        }
    }

    func setHierarchy() {
        self.addSubviews(_backgroundView, _contentView)
        _contentView.addSubviews(_grabBar, _completeImage, _completeLabel, _descriptionLabel, _shortcutButton)
    }

    func setConstraints() {
        _backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()

        }
        _contentView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        _grabBar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(50)
            $0.height.equalTo(6)
            $0.bottom.equalTo(_completeImage.snp.top).offset(-20)
        }

        _completeImage.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalTo(_descriptionLabel.snp.top).offset(-4)
        }
        
        _completeLabel.snp.makeConstraints {
            $0.centerY.equalTo(_completeImage)
            $0.leading.equalTo(_completeImage.snp.trailing).offset(8)
        }
        
        _descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(_completeLabel)
            $0.bottom.equalTo(_shortcutButton.snp.top).offset(-24)
        }

        _shortcutButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(43)
        }
    }
}

// MARK: - configure 메서드
extension ShareView {
    func successConfigure() {
        _completeImage.image = UIImage(named: "complete")
        _completeLabel.text = "저장 완료!"
        _shortcutButton.isEnabled = true
    }
    
    func failureConfigure() {
        _completeImage.image = UIImage(systemName: "xmark.circle.fill")
        _completeLabel.text = "저장 실패"
    }
}

// MARK: - UIView addSubviews
extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            self.addSubview(view)
        }
    }
}
