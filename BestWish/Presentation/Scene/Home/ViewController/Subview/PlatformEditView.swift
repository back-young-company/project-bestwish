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
    private let _backButton = UIButton()
    private let _headerView = PlatformEditHeaderView()
    private let _tableView = UITableView()

    // MARK: - Internal Property
    var backButton: UIButton { _backButton }
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
        
        _backButton.do {
            var config = UIButton.Configuration.plain()
            config.image = UIImage(systemName: "chevron.left")
            config.contentInsets = .init(top: 2, leading: 6, bottom: 2, trailing: 6)
            $0.configuration = config
            $0.tintColor = .black
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
