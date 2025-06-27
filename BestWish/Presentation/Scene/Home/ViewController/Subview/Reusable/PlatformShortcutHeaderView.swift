//
//  PlatformShortcutHeaderView.swift
//  BestWish
//
//  Created by 백래훈 on 6/11/25.
//

import UIKit

import RxSwift
import SnapKit
import Then

/// 플랫폼 바로가기 Header View
final class PlatformShortcutHeaderView: UICollectionReusableView, ReuseIdentifier {

    // MARK: - Private Property
    private let _bestWishLabel = UILabel()
    private let _titleLabel = UILabel()
    private let _editButton = UIButton()
    private var _disposeBag = DisposeBag()

    // MARK: - Internal Property
    var editButton: UIButton { _editButton }
    var disposeBag: DisposeBag { _disposeBag }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        _disposeBag = DisposeBag()
    }

    func configure(title: String) {
        _titleLabel.text = title
    }
}

// MARK: - PlatformShortcutHeaderView 설정
private extension PlatformShortcutHeaderView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        _bestWishLabel.do {
            $0.text = "BESTWISH"
            $0.textColor = .gray900
            $0.font = .font(.antonRegular, ofSize: 28)
            $0.numberOfLines = 1
        }
        
        _titleLabel.do {
            $0.textColor = .gray900
            $0.font = .font(.pretendardBold, ofSize: 16)
            $0.numberOfLines = 1
        }
        
        _editButton.do {
            $0.setTitle("편집", for: .normal)
            $0.setTitleColor(.gray200, for: .normal)
            $0.titleLabel?.font = .font(.pretendardMedium, ofSize: 12)
        }
    }

    func setHierarchy() {
        self.addSubviews(_bestWishLabel, _titleLabel, _editButton)
    }

    func setConstraints() {
        _bestWishLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(9)
            $0.leading.equalToSuperview().offset(8)
            $0.height.equalTo(28)
        }
        
        _titleLabel.snp.makeConstraints {
            $0.top.equalTo(_bestWishLabel.snp.bottom).offset(26.5)
            $0.leading.equalToSuperview().offset(8)
            $0.height.equalTo(16)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        _editButton.snp.makeConstraints {
            $0.centerY.equalTo(_titleLabel)
            $0.trailing.equalToSuperview().offset(-8)
        }
    }
}
