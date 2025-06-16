//
//  AnlaysisViewController.swift
//  BestWish
//
//  Created by Quarang on 6/12/25.
//

import UIKit
import RxSwift
import RxDataSources

// 비어 있는 키워드 예외처리를 위함
let emptyKeyword = "해당 카테고리의 키워드를 인식할 수 없습니다."

// MARK: - 이미지 분석 후 검색 뷰 컨트롤러
final class AnalaysisViewController: UIViewController {
    
    private let analysisView = AnalysisView()
    private let viewModel: AnalysisViewModel
    private var setHeaderView = false
    var disposeBag = DisposeBag()
    var previouslySelectedPlatformIndexPath: IndexPath?
    
    // 데이터 소스
    lazy var dataSource = RxCollectionViewSectionedReloadDataSource<AnalysisSectionModel>(
            configureCell: { (dataSource, collectionView, indexPath, item) in
                switch item {
                case let .keyword(keyword):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: KeywordCell.identifier,
                        for: indexPath
                    ) as? KeywordCell else { return UICollectionViewCell() }
                    cell.configure(keyword: keyword)
                    return cell
                    
                case .attribute(let attribute, let isSelected):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: AttributeCell.identifier,
                        for: indexPath
                    ) as? AttributeCell else { return UICollectionViewCell() }
                    cell.configure(attribute: attribute, isSelected: isSelected)
                    return cell
                    
                case let .platform(platform, isSelected):
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: PlatformCell.identifier,
                        for: indexPath
                    ) as? PlatformCell else { return UICollectionViewCell() }
                    cell.configure(type: platform, isSelected: isSelected)
                    return cell
                }
            }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                guard indexPath.section == 1 else { return UICollectionReusableView() }
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SegmentControlHeaderView.identifier,
                    for: indexPath
                ) as? SegmentControlHeaderView else {
                    return UICollectionReusableView()
                }
                
                // 세그먼트 컨트롤 타이틀 데이터를 이벤트로 방출
                headerView.getClassSegmentControl.rx.selectedSegmentIndex
                    .distinctUntilChanged()
                    .bind(with: self) { owner, index in
                        let category = headerView.getClassSegmentControl.titleForSegment(at: index) ?? ""
                        owner.viewModel.action.onNext(.didSelectedSegmentControl(category: category))
                    }
                    .disposed(by: headerView.disposeBag)
                return headerView
            })
    

    init(viewModel: AnalysisViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = analysisView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        bindView()
    }
    
    private func bindView() {
        // 모델 선택 시 이벤트 방출
        analysisView.getCollectionView.rx.modelSelected(AnalysisItem.self)
            .subscribe(with: self) { owner, item in
                switch item {
                case let .keyword(keyword):
                    owner.viewModel.action.onNext(.didTapKeywordChip(keyword: keyword))
                case let .attribute(attribute, _):
                    guard attribute != emptyKeyword else { return }
                    owner.viewModel.action.onNext(.didTapAttributeChip(attribute: attribute))
                case let .platform(platform, _):
                    owner.viewModel.action.onNext(.didTapPlatformChip(platform: platform))
                }
            }
            .disposed(by: disposeBag)
        
        // 라벨 데이터 컬렉션 뷰에 바인딩
        viewModel.state.labelDatas
            .bind(to: analysisView.getCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // 서치바 이벤트 방출
        analysisView.getSearchBar.rx.searchButtonClicked
            .withLatestFrom(analysisView.getSearchBar.rx.text.orEmpty)
            .subscribe(with: self) { owner, keyword in
                owner.analysisView.getSearchBar.text = nil
                owner.viewModel.action.onNext(.didSubmitSearchText(keyword: keyword))
            }
            .disposed(by: disposeBag)
    }
    
    /// 델리게이트 설정
    private func setDelegate() {
        analysisView.getCollectionView.register(KeywordCell.self, forCellWithReuseIdentifier: KeywordCell.identifier)
        analysisView.getCollectionView.register(AttributeCell.self, forCellWithReuseIdentifier: AttributeCell.identifier)
        analysisView.getCollectionView.register(PlatformCell.self, forCellWithReuseIdentifier: PlatformCell.identifier)
        analysisView.getCollectionView.register(SegmentControlHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SegmentControlHeaderView.identifier)
    }
}
