//
//  PlatformEditViewController.swift
//  BestWish
//
//  Created by 백래훈 on 6/12/25.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift

/// 플랫폼 편집 View Controller
final class PlatformEditViewController: UIViewController {

    // MARK: - Private Property
    private let platformEditViewModel: PlatformEditViewModel
    private let platformEditView = PlatformEditView()
    private let disposeBag = DisposeBag()

    private var updatedIndices: [Int] = []

    weak var delegate: HomeViewControllerUpdate?

    private lazy var dataSource = RxTableViewSectionedReloadDataSource<PlatformEditSectionModel> (configureCell: { dataSource, tableView, indexPath, item in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlatformEditCell.identifier, for: indexPath) as? PlatformEditCell else { return UITableViewCell() }
        cell.configure(type: item)

        return cell
    }, canEditRowAtIndexPath: { dataSource, indexPath in
        return true
    }, canMoveRowAtIndexPath: { dataSource, indexPath in
        return true
    })

    init(platformEditViewModel: PlatformEditViewModel) {
        self.platformEditViewModel = platformEditViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = platformEditView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        bindActions()
        
        platformEditView.tableView.isEditing = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        hidesTabBar()
        self.navigationController?.navigationBar.isHidden = false
        setNavigationBar(alignment: .center, title: "플랫폼 편집")
    }

    private func bindViewModel() {
        platformEditViewModel.state.sections
            .bind(to: platformEditView.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        platformEditViewModel.state.sections
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, sections in
                let totalItemCount = sections.flatMap { $0.items }.count
                owner.setupHeaderView(count: totalItemCount)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindActions() {
        platformEditViewModel.action.onNext(.viewDidLoad)
        
        platformEditView.tableView.rx.itemMoved
            .withLatestFrom(platformEditViewModel.state.sections) { indexPath, sections in
                return (indexPath, sections)
            }
            .subscribe(with: self) { owner, result in
                let (indexPath, sections) = result
                let sourceIndexPath = indexPath.sourceIndex
                let destinationIndexPath = indexPath.destinationIndex
                var currentItems = sections.flatMap { $0.items }
                
                let movedItem = currentItems.remove(at: sourceIndexPath.row)
                currentItems.insert(movedItem, at: destinationIndexPath.row)
                
                owner.platformEditViewModel.action.onNext(.itemMoved(currentItems))
                owner.updatedIndices = currentItems.compactMap { item in
                    PlatformEntity.allCases.firstIndex(where: { $0.platformName == item.platformName })
                }
            }
            .disposed(by: disposeBag)
        
        platformEditViewModel.state.sendDelegate
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, _ in
                owner.delegate?.updatePlatforms()
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        platformEditView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

// MARK: - private 메서드 정리
private extension PlatformEditViewController {
    /// 헤더 뷰 설정
    private func setupHeaderView(count: Int) {
        let frame = CGRect(
            x: 0,
            y: 0,
            width: platformEditView.frame.width,
            height: 40
        )
        let header = PlatformEditHeaderView(frame: frame)
        header.configure(count: count)
        platformEditView.tableView.tableHeaderView = header

        header.completeButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.platformEditViewModel.action.onNext(.updatePlatformEdit)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - 테이블 뷰 delegate
extension PlatformEditViewController: UITableViewDelegate {
    /// editing Style 설정
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    /// 재정렬 시 들여쓰기를 하지 않도록 설정 (선택사항이지만 권장)
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

/// 플랫폼 및 위시리스트 업데이트를 위한 Protocol
protocol HomeViewControllerUpdate: AnyObject {
    /// 플랫폼 업데이트
    func updatePlatforms()
    /// 위시리스트 업데이트
    func updateWishlists()
}
