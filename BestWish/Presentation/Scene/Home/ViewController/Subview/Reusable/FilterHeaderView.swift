//
//  FilterHeaderView.swift
//  BestWish
//
//  Created by 백래훈 on 6/27/25.
//

import UIKit

import SnapKit
import Then
import RxSwift

final class FilterHeaderView: UICollectionReusableView, ReuseIdentifier {
    // MARK: - Private Property
    private let _separatorView = UIView()
    private let _titleLabel = UILabel()
    private let _linkButton = UIButton()
    private let _searchBar = UISearchBar()
    private let _hStackView = UIStackView()
    private let _vStackView = UIStackView()
    private let _disposeBag = DisposeBag()

    // MARK: - Internal Property
    var linkButton: UIButton { _linkButton }
    var searchTextField: UISearchTextField { _searchBar.searchTextField }
    var disposeBag: DisposeBag { _disposeBag }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(title: String) {
        _titleLabel.text = title
    }

    func configure(isHidden: Bool) {
        _linkButton.isHidden = isHidden
        _searchBar.isHidden = isHidden
    }

}

// MARK: - FilterHeaderView 설정
private extension FilterHeaderView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        _separatorView.do {
            $0.backgroundColor = .gray50
        }

        _titleLabel.do {
            $0.textColor = .gray900
            $0.font = .font(.pretendardBold, ofSize: 16)
            $0.numberOfLines = 1

            $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
            $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }

        _linkButton.do {
            var config = UIButton.Configuration.plain()
            let titleFont = UIFont.font(.pretendardBold, ofSize: 12)

            config.attributedTitle = AttributedString("링크 저장", attributes: AttributeContainer([.font: titleFont]))
            config.baseForegroundColor = .primary200
            config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 14, bottom: 6, trailing: 14)
            $0.configuration = config
            $0.layer.cornerRadius = 8
            $0.layer.borderColor = UIColor.primary200?.cgColor
            $0.layer.borderWidth = 1.5
            $0.clipsToBounds = true

            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }

        _hStackView.do {
            $0.axis = .horizontal
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 20)
        }

        _vStackView.do {
            $0.axis = .vertical
        }

        _searchBar.do {
            $0.backgroundImage = UIImage()
            $0.placeholder = "상품 검색"
            $0.searchTextField.font = .font(.pretendardMedium, ofSize: 14)
        }
    }

    func setHierarchy() {
        self._hStackView.addArrangedSubviews(_titleLabel, _linkButton)
        self._vStackView.addArrangedSubviews(_hStackView, _searchBar)
        self.addSubviews(_separatorView, _vStackView)
    }

    func setConstraints() {
        _separatorView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(8)
        }

        _titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
        }

        _linkButton.snp.makeConstraints {
            $0.centerY.equalTo(_titleLabel)
        }

        _searchBar.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(10)
        }

        _vStackView.snp.makeConstraints {
            $0.top.equalTo(_separatorView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
