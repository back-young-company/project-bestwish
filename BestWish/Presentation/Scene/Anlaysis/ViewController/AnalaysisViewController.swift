//
//  AnlaysisViewController.swift
//  BestWish
//
//  Created by Quarang on 6/12/25.
//

import UIKit

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
                
                headerView.getClassSegmentControl.rx.selectedSegmentIndex
                    .distinctUntilChanged()
                    .filter { $0 != UISegmentedControl.noSegment } // prevent -1 crash
                    .bind(with: self) { owner, index in
                        let category = headerView.getClassSegmentControl.titleForSegment(at: index) ?? ""
                        owner.viewModel.action.onNext(.currentString(category))
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
        
        bindView()
    }
    
    private func bindView() {
        
    }
}
