//
//  TabBarView.swift
//  BestWish
//
//  Created by Quarang on 6/5/25.
//

import UIKit
import SnapKit
import Then

// MARK: - 메인 탭바 뷰
final class TabBarView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure() { }
}

private extension TabBarView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setDelegate()
        setDataSource()
        setBindings()
    }
    
    func setAttributes() {
        
    }
    
    func setHierarchy() {
        
    }
    
    func setConstraints() {
        
    }
    
    func setDelegate() {
        
    }
    
    func setDataSource() {
        
    }
    
    func setBindings() {
        
    }
}

