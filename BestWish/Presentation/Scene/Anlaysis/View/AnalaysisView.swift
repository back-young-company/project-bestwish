//
//  AnalaysisView.swift
//  BestWish
//
//  Created by Quarang on 6/12/25.
//

import UIKit
import SnapKit
import Then

// MARK: - 이미지 분석 대시보드
final class AnalysisView: UIView {
    
    private let titleLabel = UILabel()
    private let searchBar = UISearchBar()
    private let resetButton = AppButton(type: .reset)
    private let searchButton = AppButton(type: .viewProduct)
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout)
    
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
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - 접근 제어
    public var getCollectionView: UICollectionView { collectionView }
    public var getSearchBar: UISearchBar { searchBar }
}

private extension AnalysisView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }
    
    func setAttributes() {
        overrideUserInterfaceStyle = .light
        backgroundColor = .white
        
        titleLabel.do {
            $0.text = "키워드로 검색어를 만들어보세요."
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 17, weight: .bold)
        }
        
        searchBar.do {
            $0.tintColor = .black
            $0.backgroundImage = UIImage()
        }
        
        collectionView.do {
            $0.isScrollEnabled = true
            $0.showsVerticalScrollIndicator = false
        }
    }
    
    func setHierarchy() {
        addSubviews(titleLabel, searchBar, collectionView, resetButton, searchButton)
    }
    
    func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.height.equalTo(44)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(resetButton.snp.top)
        }
        
        resetButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(53)
            $0.width.equalTo(100)
            $0.bottom.equalToSuperview().offset(-24)
        }
        
        searchButton.snp.makeConstraints {
            $0.centerY.equalTo(resetButton)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(53)
            $0.leading.equalTo(resetButton.snp.trailing).offset(15)
        }
    }
}

// MARK: - 섹션 백그라운드
final class SectionBackgroundDecorationView: UICollectionReusableView, ReuseIdentifier {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.secondarySystemBackground
        layer.cornerRadius = 8
        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
