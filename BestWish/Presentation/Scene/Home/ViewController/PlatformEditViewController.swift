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

final class PlatformEditViewController: UIViewController {
    
    private let platformEditView = PlatformEditView()
    private let platformEditViewModel: PlatformEditViewModel
    
    private var updatedIndices: [Int] = []
    weak var delegate: PlatformSequenceUpdate?
    
    private let disposeBag = DisposeBag()
    
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
        
        view.backgroundColor = .systemBackground
        
        setNavigationBar()
        
        bindViewModel()
        bindActions()
        
        platformEditView.getTableView.isEditing = true
    }
    
    private func bindViewModel() {
        let dataSource = RxTableViewSectionedReloadDataSource<PlatformEditSectionModel> (configureCell: { dataSource, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PlatformEditCell.identifier, for: indexPath) as? PlatformEditCell else { return UITableViewCell() }
            cell.configure(type: item)
            
            return cell
        }, canEditRowAtIndexPath: { dataSource, indexPath in
            return true
        }, canMoveRowAtIndexPath: { dataSource, indexPath in
            return true
        })
        
        platformEditViewModel.state.sections
            .bind(to: platformEditView.getTableView.rx.items(dataSource: dataSource))
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
        
        platformEditView.getBackButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        platformEditView.getTableView.rx.itemMoved
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
                
                owner.updatedIndices = currentItems.compactMap { item in
                    ShopPlatform.allCases.firstIndex(where: { $0.platformName == item.platformName })
                }
            }
            .disposed(by: disposeBag)
        
        platformEditView.getHeaderView.getCompleteButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.platformEditViewModel.action.onNext(.updatePlatformEdit(owner.updatedIndices))
            }
            .disposed(by: disposeBag)
        
        platformEditViewModel.state.sendDelegate
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, _ in
                owner.delegate?.update()
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        platformEditView.getTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
    }
    
    private func setNavigationBar() {
        self.title = "플랫폼 편집"
        self.navigationController?.navigationBar.isHidden = false
        
        let backItem = UIBarButtonItem(customView: platformEditView.getBackButton)
        self.navigationItem.leftBarButtonItem = backItem
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [
            .font: UIFont.font(.pretendardBold, ofSize: 18),
            .foregroundColor: UIColor.black
        ]
        appearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupHeaderView(count: Int) {
        platformEditView.getHeaderView.configure(count: count)
        
        let targetSize = CGSize(width: view.bounds.width, height: 0)
        let height = platformEditView.getHeaderView.systemLayoutSizeFitting(targetSize).height
        platformEditView.getHeaderView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: height)
        platformEditView.getTableView.tableHeaderView = platformEditView.getHeaderView
    }
}

extension PlatformEditViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    // 재정렬 시 들여쓰기를 하지 않도록 설정 (선택사항이지만 권장)
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

protocol PlatformSequenceUpdate: AnyObject {
    func update()
}
