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

    // MARK: - Private Property
    private let _tableHeaderView = MyPageHeaderView()
    private let _tableView = UITableView()

    // MARK: - Internal Property
    var tableHeaderView: MyPageHeaderView { _tableHeaderView }
    var tableView: UITableView { _tableView }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - View 설정
private extension MyPageView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        _tableHeaderView.do {
            $0.isUserInteractionEnabled = true
        }

        _tableView.do {
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

            _tableHeaderView.frame = CGRect(x: 0, y: 0, width: _tableView.bounds.width, height: CGFloat(96).fitHeight)
            $0.tableHeaderView = _tableHeaderView
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
