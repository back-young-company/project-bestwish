//
//  AnlaysisViewController.swift
//  BestWish
//
//  Created by Quarang on 6/12/25.
//

import UIKit

import RxDataSources
import RxSwift

/// 이미지 분석 후 검색 뷰 컨트롤러
final class AnalaysisViewController: UIViewController {
    
    // MARK: - Private Property
    private let viewModel: AnalysisViewModel
    private let analysisView = AnalysisView()
    private let disposeBag = DisposeBag()
    
    // 데이터 소스
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<AnalysisSectionModel>(
        configureCell: { (dataSource, collectionView, indexPath, item) in
            switch item {
            case let .keyword(keyword):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: KeywordCell.identifier,
                    for: indexPath
                ) as? KeywordCell else { return UICollectionViewCell() }
                cell.configure(keyword: keyword)
                return cell
                
            case let .attribute(attribute, isSelected):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: AttributeCell.identifier,
                    for: indexPath
                ) as? AttributeCell else { return UICollectionViewCell() }
                cell.configure(attribute: attribute, isSelected: isSelected)
                return cell
                
            case let .platform(platform, isSelected):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PlatformShortcutCell.identifier,
                    for: indexPath
                ) as? PlatformShortcutCell else { return UICollectionViewCell() }
                cell.configure(type: platform, isSelected: isSelected)
                return cell
            }
        }, configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
            guard let self, indexPath.section == 1 else { return UICollectionReusableView() }
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SegmentControlHeaderView.identifier,
                for: indexPath
            ) as? SegmentControlHeaderView else {
                return UICollectionReusableView()
            }
            // ViewModeml과 SegmentControl의 index 바인딩
            self.viewModel.state.segmentIndex
                .bind(to: headerView.classSegmentControl.rx.selectedSegmentIndex)
                .disposed(by: headerView.disposeBag)
            
            // SegmentControl 변경에 따른 이벤트 방출
            headerView.classSegmentControl.rx.selectedSegmentIndex
                .distinctUntilChanged()
                .compactMap { index in headerView.classSegmentControl.titleForSegment(at: index) }
                .bind(with: self) { owner, category in
                    owner.viewModel.action.onNext(.didSelectedSegmentControl(category: category))
                }
                .disposed(by: disposeBag)
            
            return headerView
        }
    )
    
    
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
        
        bindViewModel()
        viewModel.action.onNext(.viewDidLoad)
    }
    
    private func bindViewModel() {
        // 모델 선택 시 이벤트 방출
        analysisView.collectionView.rx.modelSelected(AnalysisItem.self)
            .subscribe(with: self) { owner, item in
                switch item {
                case let .keyword(keyword):
                    owner.viewModel.action.onNext(.didTapKeywordChip(keyword: keyword))
                case let .attribute(attribute, _):
                    guard attribute != EmptyCategoryCase.emptyKeyword.rawValue else { return }
                    owner.viewModel.action.onNext(.didTapAttributeChip(attribute: attribute))
                case let .platform(platform, _):
                    owner.viewModel.action.onNext(.didTapPlatformChip(platform: platform))
                }
            }
            .disposed(by: disposeBag)
        
        // 서치바 이벤트 방출
        analysisView.searchBar.rx.searchButtonClicked
            .withLatestFrom(analysisView.searchBar.rx.text.orEmpty)
            .subscribe(with: self) { owner, keyword in
                owner.analysisView.searchBar.text = nil
                owner.viewModel.action.onNext(.didSubmitSearchText(keyword: keyword))
            }
            .disposed(by: disposeBag)
        
        // 초기화 이벤트 방출
        analysisView.restButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.viewModel.action.onNext(.didTapResetButton)
            }
            .disposed(by: disposeBag)
        
        // 상품 보기 이벤트 방출
        analysisView.searchButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.viewModel.action.onNext(.didTapSearchButton)
            }
            .disposed(by: disposeBag)
        
        // 라벨 데이터 컬렉션 뷰에 바인딩
        viewModel.state.models
            .bind(to: analysisView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // 타 플랫 폼 이동
        viewModel.state.deepLink
            .subscribe(with: self) { owner, deepLink in
                guard let url = URL(string: deepLink) else {
                    return NSLog("❌ 유효하지 않는 URL")
                }
                UIApplication.shared.open(url, options: [:]) { success in
                    guard success else {
                        NSLog("❌ 앱 전환 실패: \(url.absoluteString)")
                        return
                    }
                    NSLog("✅ 앱 전환 성공: \(url.absoluteString)")
                }
            }
            .disposed(by: disposeBag)
        
        // 플랫폼 이동 에러 시
        viewModel.state.deepLinkError
            .subscribe(with: self) { owner, error in
                owner.showBasicAlert(title: "미지원 플랫폼", message: error.rawValue)
            }
            .disposed(by: disposeBag)
        
        // 데이터를 선택하지 않으면 버튼 비활성화
        viewModel.state.buttonActivation
            .subscribe(with: self) { owner, isActivated in
                owner.analysisView.configure(isActivated)
            }
            .disposed(by: disposeBag)
    }
}
