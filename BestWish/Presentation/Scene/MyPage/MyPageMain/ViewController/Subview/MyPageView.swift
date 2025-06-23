//
//  MyPageView.swift
//  BestWish
//
//  Created by 이수현 on 6/9/25.
//

import UIKit

import SnapKit
import Then

final class MyPageView: UIView {
    private let _tableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    var tableView: UITableView { _tableView }
}

private extension MyPageView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        tableView.do {
            $0.register(
                MyPageHeaderView.self,
                forHeaderFooterViewReuseIdentifier: MyPageHeaderView.identifier
            )
            $0.register(
                MyPageCell.self,
                forCellReuseIdentifier: MyPageCell.identifier
            )
            $0.separatorStyle = .none
            $0.rowHeight = CGFloat(43).fitHeight
            $0.sectionHeaderTopPadding = 16
            $0.sectionFooterHeight = 16
        }
    }

    func setHierarchy() {
        addSubviews(_tableView)
    }

    func setConstraints() {
        _tableView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.bottom.directionalHorizontalEdges.equalToSuperview()
        }
    }
}
