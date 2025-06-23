//
//  TabBarView.swift
//  BestWish
//
//  Created by Quarang on 6/5/25.
//

import UIKit

import SnapKit
import Then

// 메인 탭바 뷰
final class TabBarView: UIView {
    
    // MARK: - Private Property
    private let _leftItemButton = UIButton()     // 홈 버튼 혹은 사진첩 버튼
    private let _rightItemButton = UIButton()    // 마이페이지 버튼 혹은 화면전환 버튼
    private let _centerItemButton = UIButton()   // 센터 플로팅 버튼 사진 찍기 버튼 및 사진 모드로 변경 버튼
    private let tabBar = UIView()                // 탭바 컨테이너
    
    // MARK: - Internal Property
    public var leftItemButton: UIButton { _leftItemButton }
    public var rightItemButton: UIButton { _rightItemButton }
    public var centerItemButton: UIButton { _centerItemButton }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tabBar.updateShadowPath()
    }

    /// 탭바 숨김
    func setTabBarHidden(_ hidden: Bool) {
        NSLog(#function, hidden)
        if hidden {
            UIView.animate(withDuration: 0.15, animations: { [weak self] in
                self?.tabBar.alpha = 0
            }, completion: { [weak self] _ in
                self?.tabBar.isHidden = hidden
            })
        } else {
            tabBar.isHidden = hidden
            UIView.animate(withDuration: 0.15, animations: { [weak self] in
                self?.tabBar.alpha = 1
            })
        }
    }
}

// MARK: - 탭바 설정
private extension TabBarView {
    
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }
    
    func setAttributes() {
        tabBar.do {
            $0.backgroundColor = .gray0
            $0.layer.cornerRadius = 24
            $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOffset = .init(width: 0, height: -4)
            $0.layer.shadowOpacity = 0.2
            $0.layer.shadowRadius = 8
        }
       
        _leftItemButton.do {
            $0.contentVerticalAlignment = .fill
            $0.contentHorizontalAlignment = .fill
        }
        
        _centerItemButton.do {
            $0.setImage(UIImage(named: "home_de2"), for: .normal)
            $0.contentVerticalAlignment = .fill
            $0.contentHorizontalAlignment = .fill
        }
        
        _rightItemButton.do {
            $0.contentVerticalAlignment = .fill
            $0.contentHorizontalAlignment = .fill
        }
    }
    
    func setHierarchy() {
        addSubviews(tabBar)
        tabBar.addSubviews(_leftItemButton, _centerItemButton, _rightItemButton)
    }
    
    func setConstraints() {
        
        tabBar.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(UIScreen.main.bounds.height < 700 ? 84 : 120)
        }
        
        let screenHeight = UIScreen.main.bounds.height
        let baseHeight: CGFloat = 844 // iPhone 14 height for baseline
        let scaleFactor = screenHeight / baseHeight

        _leftItemButton.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(UIScreen.main.bounds.height < 700 ? 0 : -16)
            $0.leading.equalToSuperview().inset(48)
            $0.width.equalTo(64 * scaleFactor)
            $0.height.equalTo(80 * scaleFactor)
        }

        _centerItemButton.snp.makeConstraints {
            $0.centerX.equalTo(tabBar.snp.centerX)
            $0.centerY.equalTo(tabBar.snp.top).offset(8 * scaleFactor)
            $0.width.height.equalTo(84 * scaleFactor)
        }

        _rightItemButton.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(UIScreen.main.bounds.height < 700 ? 0 : -16)
            $0.trailing.equalToSuperview().inset(48)
            $0.width.equalTo(64 * scaleFactor)
            $0.height.equalTo(80 * scaleFactor)
        }
    }
}
