//
//  MyPageView.swift
//  BestWish
//
//  Created by 이수현 on 6/9/25.
//

import UIKit

final class MyPageView: UIView {
    let tableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
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
            $0.allowsSelection = false
            $0.rowHeight = CGFloat(43).fitHeight
            $0.sectionHeaderTopPadding = 16
            $0.sectionFooterHeight = 16
        }
    }

    func setHierarchy() {
        addSubviews(tableView)
    }

    func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.bottom.directionalHorizontalEdges.equalToSuperview()
        }
    }
}
