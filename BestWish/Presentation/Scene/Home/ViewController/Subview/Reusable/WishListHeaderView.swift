//
//  WishListHeaderView.swift
//  BestWish
//
//  Created by 백래훈 on 6/11/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

/// 위시리스트 Header View
final class WishListHeaderView: UICollectionReusableView, ReuseIdentifier {

    // MARK: - Private Property
    private let _separatorView = UIView()
    private let _titleLabel = UILabel()
    private let _linkButton = UIButton()
    private let _searchBar = UISearchBar()
    private let _platformCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let _productCountLabel = UILabel()
    private let _editButton = UIButton()
    private var _disposeBag = DisposeBag()

    private var selectedPlatform: Int = 0

    // MARK: - Internal Property
    // ✅ 클릭된 플랫폼 index를 외부로 전달하는 relay
    let selectedPlatformRelay = BehaviorRelay<Int>(value: 0)
    var linkButton: UIButton { _linkButton }
    var editButton: UIButton { _editButton }
    var searchBar: UISearchBar { _searchBar }
    var searchTextField: UITextField { _searchBar.searchTextField }
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
    
    func configure(productCount: Int) {
        _productCountLabel.text = "\(productCount)개"
    }
    
    func configure(platforms: Observable<[(Int ,Int)]>) {
        platforms
            .bind(to: _platformCollectionView.rx.items(cellIdentifier: WishListFilterCell.identifier, cellType: WishListFilterCell.self)) { [weak self] row, data, cell in
                guard let self else { return }
                let (platform, _) = data
                let selectedPlatform = self.selectedPlatformRelay.value
                let isSelected = (platform == selectedPlatform)
                
//                cell.configure(type: platform, isSelected: isSelected)
                cell.platformButton.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.selectedPlatform = platform
                        owner._platformCollectionView.reloadData()
                        
                        // ✅ 클릭된 플랫폼 index 전달
                        owner.selectedPlatformRelay.accept(platform)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: _disposeBag)
    }
}

// MARK: - WishListHeaderView 설정
private extension WishListHeaderView {
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
        }
        
        _searchBar.do {
            $0.backgroundImage = UIImage()
            $0.placeholder = "상품 검색"
            $0.searchTextField.font = .font(.pretendardMedium, ofSize: 14)
        }
        
        _platformCollectionView.do {
            $0.register(
                WishListFilterCell.self,
                forCellWithReuseIdentifier: WishListFilterCell.identifier
            )
            let layout = UICollectionViewFlowLayout()
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 9
            layout.minimumLineSpacing = 5
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            $0.collectionViewLayout = layout
            $0.showsHorizontalScrollIndicator = false
        }
        
        _productCountLabel.do {
            $0.textColor = .gray200
            $0.font = .font(.pretendardMedium, ofSize: 12)
        }
        
        _editButton.do {
            $0.setTitle("편집", for: .normal)
            $0.setTitleColor(.gray200, for: .normal)
            $0.titleLabel?.font = .font(.pretendardMedium, ofSize: 12)
        }
    }

    func setHierarchy() {
        self.addSubviews(_separatorView, _titleLabel, _linkButton, _searchBar, _platformCollectionView, _productCountLabel, _editButton)
    }

    func setConstraints() {
        _separatorView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(8)
        }
        
        _titleLabel.snp.makeConstraints {
            $0.top.equalTo(_separatorView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(16)
        }
        
        _linkButton.snp.makeConstraints {
            $0.centerY.equalTo(_titleLabel)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        _searchBar.snp.makeConstraints {
            $0.top.equalTo(_titleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        _searchBar.searchTextField.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        _platformCollectionView.snp.makeConstraints {
            $0.top.equalTo(_searchBar.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(49)
        }
        
        _productCountLabel.snp.makeConstraints {
            $0.top.equalTo(_platformCollectionView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        _editButton.snp.makeConstraints {
            $0.centerY.equalTo(_productCountLabel)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
}
