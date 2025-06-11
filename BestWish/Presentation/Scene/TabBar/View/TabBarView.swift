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
    
    // MARK: - 속성 정의
    
    /// 홈 버튼 혹은 사진첩 버튼
    private let leftItemButton = UIButton()
    
    /// 마이페이지 버튼 혹은 화면전환 버튼
    private let rightItemButton = UIButton()
    
    /// 센터 플로팅 버튼 사진 찍기 버튼 및 사진 모드로 변경 버튼
    private let centerItemButton = UIButton()
    
    /// 탭바 컨테이너
    private let tabBar = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure() { }
    
    public var getLeftItemButton: UIButton { leftItemButton }
    
    public var getRightItemButton: UIButton { rightItemButton }
    
    public var getCenterItemButton: UIButton { centerItemButton }
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
        
        tabBar.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 24
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOffset = .init(width: 0, height: -4)
            $0.layer.shadowOpacity = 0.2
            $0.layer.shadowRadius = 8
        }
        
       
        leftItemButton.do {
            $0.contentVerticalAlignment = .fill
            $0.contentHorizontalAlignment = .fill
        }
        
        centerItemButton.do {
            $0.setImage(UIImage(named: "home_de2"), for: .normal)
            $0.contentVerticalAlignment = .fill
            $0.contentHorizontalAlignment = .fill
        }
        
        rightItemButton.do {
            $0.contentVerticalAlignment = .fill
            $0.contentHorizontalAlignment = .fill
        }
    }
    
    func setHierarchy() {
        addSubviews(tabBar)
        tabBar.addSubviews(leftItemButton, centerItemButton, rightItemButton)
    }
    
    func setConstraints() {
        
        tabBar.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height < 700 ? 84 : 120)
        }
        
        leftItemButton.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(UIScreen.main.bounds.height < 700 ? 0 : -16)
            $0.leading.equalToSuperview().inset(48)
            $0.width.equalTo(64)
            $0.height.equalTo(80)
        }
        
        centerItemButton.snp.makeConstraints {
            $0.centerX.equalTo(tabBar.snp.centerX)
            $0.centerY.equalTo(tabBar.snp.top).offset(8)
            $0.width.height.equalTo(84)
        }
        
        rightItemButton.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(UIScreen.main.bounds.height < 700 ? 0 : -16)
            $0.trailing.equalToSuperview().inset(48)
            $0.width.equalTo(64)
            $0.height.equalTo(80)
        }
    }
    
    func setDelegate() {
        
    }
    
    func setDataSource() {
        
    }
    
    func setBindings() {
        
    }
}

