//
//  PlatformEditView.swift
//  BestWish
//
//  Created by 백래훈 on 6/12/25.
//

import UIKit

import SnapKit
import Then

final class PlatformEditView: UIView {
    
    private let backButton = UIButton()
    private let headerView = PlatformEditHeaderView()
    private let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    var getBackButton: UIButton { backButton }
    var getHeaderView: PlatformEditHeaderView { headerView }
    var getTableView: UITableView { tableView }
}

private extension PlatformEditView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        self.backgroundColor = .white
        
        tableView.do {
            $0.register(
                PlatformEditCell.self,
                forCellReuseIdentifier: PlatformEditCell.identifier)
            $0.separatorStyle = .none
        }
        
        backButton.do {
            var config = UIButton.Configuration.plain()
            config.image = UIImage(systemName: "chevron.left")
            config.contentInsets = .init(top: 2, leading: 6, bottom: 2, trailing: 6)
            $0.configuration = config
            $0.tintColor = .black
        }
    }

    func setHierarchy() {
        self.addSubview(tableView)
    }

    func setConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
