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
            }
        },
        titleForHeaderInSection: { dataSource, index in
            return dataSource.sectionModels[index].header
        },
        titleForFooterInSection: { dataSource, index in
            return dataSource.sectionModels[index].footer
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

        bindViewModel()
        setHeaderView()
    }

    private func bindViewModel() {
        viewModel.state.sections
            .bind(to: myPageView.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        viewModel.state.userInfo
            .bind(to: userInfo)
            .disposed(by: disposeBag)
    }

    private func setHeaderView() {
        guard let userInfo = userInfo.value else { return }
        let frame = CGRect(
            x: 0,
            y: 0,
            width: myPageView.frame.width,
            height: CGFloat(96).fitHeight
        )
        let header = MyPageHeaderView(frame: frame)

        header.configure(
            profileImage: UIImage(systemName: userInfo.profileImageName) ?? .add,
            nickname: userInfo.nickname,
            email: userInfo.email
        )
        myPageView.tableView.tableHeaderView = header
    }
}
