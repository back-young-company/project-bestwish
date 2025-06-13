//
//  WishlistHeaderView.swift
//  BestWish
//
//  Created by 백래훈 on 6/11/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class WishlistHeaderView: UICollectionReusableView, ReuseIdentifier {
    
    private let separatorView = UIView()
    
    private let titleLabel = UILabel()
    private let linkButton = UIButton()
    
    private let searchBar = UISearchBar()
    
    private let platformCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let productCountLabel = UILabel()
    private let editButton = UIButton()
    
    private var selectedPlatform: String = "전체"
    
    var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }

    func configure(title: String) {
        titleLabel.text = title
    }
    
    func configure(productCount: Int) {
        productCountLabel.text = "\(productCount)개"
    }
    
    func configure(platforms: Observable<[String]>) {
        platforms
            .bind(to: platformCollectionView.rx.items(cellIdentifier: WishlistPlatformCell.identifier, cellType: WishlistPlatformCell.self)) { row, data, cell in
                let isSelected = (data == self.selectedPlatform)
                cell.configure(type: data, isSelected: isSelected)
                
                cell.getPlatformButton().rx.tap
                    .bind(with: self) { owner, _ in
                        owner.selectedPlatform = data
                        owner.platformCollectionView.reloadData()
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
    
    func getEditButton() -> UIButton { editButton }
}

private extension WishlistHeaderView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        separatorView.do {
            $0.backgroundColor = .gray50
        }
        
        titleLabel.do {
            $0.textColor = .gray900
            $0.font = .font(.pretendardBold, ofSize: 16)
            $0.numberOfLines = 1
        }
        
        linkButton.do {
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
        
        searchBar.do {
            $0.backgroundImage = UIImage()
            $0.placeholder = "상품 검색"
            $0.searchTextField.font = .font(.pretendardMedium, ofSize: 14)
        }
        
        platformCollectionView.do {
            $0.register(
                WishlistPlatformCell.self,
                forCellWithReuseIdentifier: WishlistPlatformCell.identifier
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
        
        productCountLabel.do {
            $0.textColor = .gray200
            $0.font = .font(.pretendardMedium, ofSize: 12)
        }
        
        editButton.do {
            $0.setTitle("편집", for: .normal)
            $0.setTitleColor(.gray200, for: .normal)
            $0.titleLabel?.font = .font(.pretendardMedium, ofSize: 12)
        }
    }

    func setHierarchy() {
        self.addSubviews(separatorView, titleLabel, linkButton, searchBar, platformCollectionView, productCountLabel, editButton)
    }

    func setConstraints() {
        separatorView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(8)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        linkButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.height.equalTo(40)
        }
        
        platformCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(49)
        }
        
        productCountLabel.snp.makeConstraints {
            $0.top.equalTo(platformCollectionView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        editButton.snp.makeConstraints {
            $0.centerY.equalTo(productCountLabel)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
}
