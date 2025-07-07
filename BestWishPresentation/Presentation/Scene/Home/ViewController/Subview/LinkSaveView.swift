//
//  LinkSaveView.swift
//  BestWish
//
//  Created by 백래훈 on 6/13/25.
//

import UIKit

internal import RxSwift
internal import SnapKit
internal import Then

/// 상품 추가 View
final class LinkSaveView: UIView {

    // MARK: - Private Property
    private let _saveButton: AppButton

    private let _linkView = UIView()
    private let _titleLabel = UILabel()
    private let _cancelButton = UIButton()
    private let _linkInputView = UISearchBar()

    // MARK: - Internal Property
    var linkView: UIView { _linkView }
    var linkInputTextField: UITextField { _linkInputView.searchTextField }
    var cancelButton: UIButton { _cancelButton }
    var saveButton: AppButton { _saveButton }

    init() {
        self._saveButton = AppButton(type: .save)

        super.init(frame: .zero)

        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

private extension LinkSaveView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        self.backgroundColor = .black.withAlphaComponent(0.5)

        _linkView.do {
            $0.backgroundColor = .gray0
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }

        _titleLabel.do {
            $0.text = "상품 추가"
            $0.textColor = .gray900
            $0.font = .font(.pretendardBold, ofSize: 18)
            $0.textAlignment = .center
        }
        
        _cancelButton.do {
            var config = UIButton.Configuration.plain()
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)
            
            config.image = UIImage(systemName: "xmark")?.withConfiguration(symbolConfig)
            config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            $0.configuration = config
            $0.tintColor = .gray900
        }

        _linkInputView.do {
            $0.backgroundImage = UIImage()
            $0.searchTextField.attributedPlaceholder = NSAttributedString(
                string: "링크를 붙여주세요",
                attributes: [
                    .foregroundColor: UIColor.gray400 ?? .black,
                    .font: UIFont.font(.pretendardBold, ofSize: 14)
                ]
            )
            $0.searchTextField.font = .font(.pretendardBold, ofSize: 14)
            $0.searchTextField.textColor = .gray900

            let image = UIImage(named: "link")?.withRenderingMode(.alwaysOriginal)
            $0.setImage(image, for: .search, state: .normal)
            $0.searchTextField.leftView?.tintColor = .gray200
        }
    }

    func setHierarchy() {
        self.addSubviews(_linkView)
        _linkView.addSubviews(_titleLabel, _cancelButton, _linkInputView, _saveButton)
    }

    func setConstraints() {
        _linkView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        _titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        _cancelButton.snp.makeConstraints {
            $0.centerY.equalTo(_titleLabel)
            $0.trailing.equalToSuperview().offset(-12)
        }

        _linkInputView.snp.makeConstraints {
            $0.top.equalTo(_titleLabel.snp.bottom).offset(25)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(49)
        }
        
        _linkInputView.searchTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalToSuperview()
        }

        _saveButton.snp.makeConstraints {
            $0.top.equalTo(_linkInputView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(43)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
}
