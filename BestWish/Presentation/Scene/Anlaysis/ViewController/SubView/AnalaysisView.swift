//
//  AnalaysisView.swift
//  BestWish
//
//  Created by Quarang on 6/12/25.
//

import UIKit

import SnapKit
import Then

/// 이미지 분석 대시보드
final class AnalysisView: UIView {
    
    // MARK: - Private Property
    private let _titleLabel = UILabel()
    private let _searchBar = UISearchBar()
    private let _resetButton = AppButton(type: .reset)
    private let _searchButton = AppButton(type: .viewProduct)
    private lazy var _collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout)
    
    // MARK: - Internal Property
    var collectionView: UICollectionView { _collectionView }
    var searchBar: UISearchBar { _searchBar }
    var restButton: UIButton { _resetButton }
    var searchButton: UIButton { _searchButton }
    
    /// 섹션 정의
    func createAnlaysisSection(_ index: Int) -> NSCollectionLayoutSection {
        let sectionType = AnalysisSectionType(rawValue: index)
        
        // 섹션 별 아이템 및 그룹 사이즈 정의
        let keywordAttributeItemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(70),
            heightDimension: .fractionalHeight(1.0)
        )
        let keywordAttributeGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(CGFloat(26).fitWidth)
        )
        let defaultItemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(80),
            heightDimension: .absolute(102)
        )
        let defaultGroupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(500),
            heightDimension: .absolute(102)
        )
        
        let itemSize: NSCollectionLayoutSize
        let groupSize: NSCollectionLayoutSize
        
        switch sectionType {
        case .keyword, .attribute:
            itemSize = keywordAttributeItemSize
            groupSize = keywordAttributeGroupSize
        default:
            itemSize = defaultItemSize
            groupSize = defaultGroupSize
        }
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        
        // 그룹 및 섹션 설정
        switch sectionType {
        case .keyword, .attribute:
            group.interItemSpacing = .fixed(8)
            if sectionType == .attribute {
                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            }
            
        default:
            group.interItemSpacing = .fixed(2)
        }
        
        let section = NSCollectionLayoutSection(group: group)
        
        switch sectionType {
        case .keyword, .attribute: section.orthogonalScrollingBehavior = .none
        default: section.orthogonalScrollingBehavior = .continuous
        }
        
        section.interGroupSpacing = 8
        
        switch sectionType {
        case .keyword:
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)
        case .attribute:
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 16, trailing: 0)
            
            // 섹션 헤더 설정
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(40)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [sectionHeader]
            
            // 배경 색 지정
            let backgroundItem = NSCollectionLayoutDecorationItem.background(
                elementKind: SectionBackgroundDecorationView.identifier
            )
            backgroundItem.contentInsets = NSDirectionalEdgeInsets(top: 48, leading: 0, bottom: 0, trailing: 0)
            section.decorationItems = [backgroundItem]
        default:
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0)
        }
        
        return section
    }
    
    // 레이아웃 정의
    var createLayout: UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            self.createAnlaysisSection(sectionIndex)
        }
        layout.register(
            SectionBackgroundDecorationView.self,
            forDecorationViewOfKind: SectionBackgroundDecorationView.identifier
        )
        return layout
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    public func configure(_ isActivated: Bool) {
        _searchButton.isEnabled = isActivated
    }
}

// MARK: - 이미지 분석 뷰 설정
private extension AnalysisView {
    func setView() {
        setAttributes()
        setRegister()
        setHierarchy()
        setConstraints()
    }
    
    func setAttributes() {
        overrideUserInterfaceStyle = .light
        backgroundColor = .gray0
        
        _titleLabel.do {
            $0.text = "키워드로 검색어를 만들어보세요."
            $0.textColor = .gray900
            $0.font = .font(.pretendardBold, ofSize: 17)
        }
        
        _searchBar.do {
            $0.tintColor = .gray900
            $0.backgroundImage = UIImage()
        }
        
        _collectionView.do {
            $0.isScrollEnabled = true
            $0.showsVerticalScrollIndicator = false
        }
    }
    
    func setHierarchy() {
        addSubviews(_titleLabel, _searchBar, _collectionView, _resetButton, _searchButton)
    }
    
    func setRegister() {
        _collectionView.register(KeywordCell.self, forCellWithReuseIdentifier: KeywordCell.identifier)
        _collectionView.register(AttributeCell.self, forCellWithReuseIdentifier: AttributeCell.identifier)
        _collectionView.register(PlatformShortcutCell.self, forCellWithReuseIdentifier: PlatformShortcutCell.identifier)
        _collectionView.register(SegmentControlHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SegmentControlHeaderView.identifier)
    }
    
    func setConstraints() {
        _titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(50)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        _searchBar.snp.makeConstraints {
            $0.top.equalTo(_titleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.height.equalTo(44)
        }
        
        _collectionView.snp.makeConstraints {
            $0.top.equalTo(_searchBar.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(_resetButton.snp.top).offset(-10)
        }
        
        _resetButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(53)
            $0.width.equalTo(100)
            $0.bottom.equalToSuperview().offset(-24)
        }
        
        _searchButton.snp.makeConstraints {
            $0.centerY.equalTo(_resetButton)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(53)
            $0.leading.equalTo(_resetButton.snp.trailing).offset(15)
        }
    }
}

