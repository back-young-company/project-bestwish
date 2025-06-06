//
//  TabBarController.swift
//  BestWish
//
//  Created by Quarang on 6/5/25.
//

import UIKit
import RxSwift
import RxCocoa

// MARK: - 메인 탭바 컨트롤러
final class TabBarViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let tabBarView = TabBarView()
    private let selectedIndex = BehaviorRelay(value: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    override func loadView() {
        view = tabBarView
    }
    
    private func bindViewModel() {
        
        tabBarView.getLeftItemButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.selectedIndex.accept(0)
            }
            .disposed(by: disposeBag)
        
        tabBarView.getCenterItemButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.selectedIndex.accept(1)
            }
            .disposed(by: disposeBag)
        
        tabBarView.getRightItemButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.selectedIndex.accept(2)
            }
            .disposed(by: disposeBag)
        
        selectedIndex
            .subscribe(with: self) { owner, index in
                owner.changedTabBarItem(index)
            }
            .disposed(by: disposeBag)
    }
    
    /// 탭바 아이템 변경 시 호출되는 메서드
    private func changedTabBarItem(_ index: Int) {
        switch index {
        case 0:
            tabBarView.getLeftItemButton.setImage(UIImage(named: "state=se1"), for: .normal)
            tabBarView.getLeftItemButton.setImage(UIImage(named: "state=pu1"), for: .highlighted)
            tabBarView.getRightItemButton.setImage(UIImage(named: "state=de3"), for: .normal)
            tabBarView.backgroundColor = .systemBlue
        case 1:
            tabBarView.getCenterItemButton.setImage(UIImage(named: "state=se2"), for: .normal)
        case 2:
            tabBarView.getRightItemButton.setImage(UIImage(named: "state=se3"), for: .normal)
            tabBarView.getRightItemButton.setImage(UIImage(named: "state=pu3"), for: .highlighted)
            tabBarView.getLeftItemButton.setImage(UIImage(named: "state=de1"), for: .normal)
            tabBarView.backgroundColor = .systemPink
        default: return
        }
    }
}

