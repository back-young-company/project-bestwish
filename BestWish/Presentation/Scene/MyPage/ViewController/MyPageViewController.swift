//
//  MyPageViewController.swift
//  BestWish
//
//  Created by 이수현 on 6/9/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class MyPageViewController: UIViewController {
    private let myPageView = MyPageView()
    private let viewModel: MyPageViewModel
    private let disposeBag = DisposeBag()
    private let userInfo = BehaviorRelay<AccountDisplay?>(value: nil)
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<MyPageSection>(
        configureCell: { dataSource, tableView, indexPath, item in
            switch item {
            case .basic(let type), .seeMore(let type):
                guard let cell = self.myPageView.tableView.dequeueReusableCell(
                    withIdentifier: MyPageCell.identifier,
                    for: indexPath
                ) as? MyPageCell else {
                    return UITableViewCell()
                }
                cell.configure(type: type)
                return cell
            case .empty:
                return UITableViewCell()
            }
        },
        titleForHeaderInSection: { dataSource, index in
            return dataSource.sectionModels[index].header
        }
    )

    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.setLeftBarItem(with: "마이페이지")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = myPageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindView()
        bindViewModel()
    }

    private func bindView() {
        myPageView.tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }

    private func bindViewModel() {
        viewModel.state.sections
            .bind(to: myPageView.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        viewModel.state.userInfo
            .bind(to: userInfo)
            .disposed(by: disposeBag)
    }
}

extension MyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch MyPageSectionType(rawValue: section) {
        case .userAccount:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: MyPageHeaderView.identifier
            ) as? MyPageHeaderView, let dataSource = userInfo.value else {
                return nil
            }

            headerView.configure(
                profileImage: UIImage(systemName: dataSource.profileImageName) ?? .add,
                nickname: dataSource.nickname,
                email: dataSource.email
            )
            return headerView
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch MyPageSectionType(rawValue: section) {
        case . userAccount:
            return CGFloat(96).fitHeight
        default:
            return 44
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch MyPageSectionType(rawValue: section) {
        case . userAccount:
            let view = UIView()
            view.backgroundColor = .gray50
            return view
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch MyPageSectionType(rawValue: section) {
        case . userAccount: 8
        default: 32
        }
    }
}
