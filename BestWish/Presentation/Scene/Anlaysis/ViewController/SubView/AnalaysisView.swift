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
    private let _buttonStackView = HorizontalStackView(spacing: 20)
    private lazy var _collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout)
    
    // MARK: - Internal Property
    var collectionView: UICollectionView { _collectionView }
    var searchBar: UISearchBar { _searchBar }
    var restButton: UIButton { _resetButton }
    var searchButton: UIButton { _searchButton }
    
    // 레이아웃 정의
    var createLayout: UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
            case 0: return NSCollectionLayoutSection.createKeywordSection()
            case 1: return NSCollectionLayoutSection.createAttributeSection()
            default: return NSCollectionLayoutSection.createPlatformSection()
            }
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
        addSubviews(_titleLabel, _searchBar, _collectionView, _buttonStackView)
        _buttonStackView.addSubviews(_resetButton, _searchButton)
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
            $0.bottom.equalTo(_buttonStackView.snp.top).offset(-20)
        }
        
        _buttonStackView.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(CGFloat(44).fitHeight)
        }
        
        _resetButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(CGFloat(53).fitHeight)
            $0.width.equalTo(95)
        }
        
        _searchButton.snp.makeConstraints {
            $0.height.equalTo(CGFloat(53).fitHeight)
            $0.leading.equalTo(_resetButton.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}

