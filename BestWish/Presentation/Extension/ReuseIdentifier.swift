//
//  ReuseIdentifier.swift
//  BestWish
//
//  Created by 이수현 on 6/5/25.
//

import Foundation

/// 셀 재사용 시 identifier를 편리하게  사용할 수 있는 프로토콜입니다
///
/// ```swift
/// class VerticalCell: UITableViewCell, ReuseIdentifier { }
///
/// ...
/// func setTableView() {
///     let tableView = tableView()
///     tableView.register(
///         VerticlCell.self,
///         forCellReuseIdentifier: VerticlCell.identifier
///     )
/// }
/// ```
protocol ReuseIdentifier: AnyObject {
    static var identifier: String { get }
}

extension ReuseIdentifier {
    static var identifier: String {
        String(describing: self)
    }
}
