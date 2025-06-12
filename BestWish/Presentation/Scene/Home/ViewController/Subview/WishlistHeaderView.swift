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
    
    let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(title: String) {
        titleLabel.text = title
    }
}

private extension WishlistHeaderView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setPlatformCollectionView()
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
            let titleFont = UIFont.font(.pretendardBold, ofSize: 14)
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .regular)

            config.attributedTitle = AttributedString("링크 저장", attributes: AttributeContainer([.font: titleFont]))
            config.baseForegroundColor = .primary200
            config.image = UIImage(systemName: "plus")?.withConfiguration(symbolConfig)
            config.imagePlacement = .trailing
            config.imagePadding = 4
            config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6)
            $0.configuration = config
        }
        
        searchBar.do {
            $0.backgroundImage = UIImage()
            $0.placeholder = "상품 검색"
            $0.searchTextField.font = .font(.pretendardMedium, ofSize: 14)
        }
        
        platformCollectionView.do {
            $0.register(
                PlatformCollectionViewCell.self,
                forCellWithReuseIdentifier: PlatformCollectionViewCell.identifier
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
            $0.text = "5개"
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

private extension WishlistHeaderView {
    func setPlatformCollectionView() {
        Observable.just(["전체", "무신사", "에이블리", "지그재그재그재그", "전체", "무신사", "에이블리", "지그재그재그"])
            .bind(to: platformCollectionView.rx.items(cellIdentifier: PlatformCollectionViewCell.identifier, cellType: PlatformCollectionViewCell.self)) { row, data, cell in
                
                cell.configure(type: data)
                
            }
            .disposed(by: disposeBag)
    }
}
