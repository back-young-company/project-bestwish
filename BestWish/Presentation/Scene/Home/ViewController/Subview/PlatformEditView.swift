//
//  PlatformEditView.swift
//  BestWish
//
//  Created by 백래훈 on 6/12/25.
//

import UIKit

import SnapKit
import Then

/// 플랫폼 편집 View
final class PlatformEditView: UIView {

    // MARK: - Private Property
    private let _headerView = PlatformEditHeaderView()
    private let _tableView = UITableView()

    // MARK: - Internal Property
    var headerView: PlatformEditHeaderView { _headerView }
    var tableView: UITableView { _tableView }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - PlatformEditView 설정
private extension PlatformEditView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        self.backgroundColor = .white
        
        _tableView.do {
            $0.register(
                PlatformEditCell.self,
                forCellReuseIdentifier: PlatformEditCell.identifier)
            $0.separatorStyle = .none
        }
    }

    func setHierarchy() {
        self.addSubview(_tableView)
    }

    func setConstraints() {
        _tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
