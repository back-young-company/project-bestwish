//
//  TabBarController.swift
//  BestWish
//
//  Created by Quarang on 6/5/25.
//

import UIKit

// MARK: - 메인 탭바 컨트롤러
final class TabBarViewController: UIViewController {

    private let tabBarView = TabBarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        view = tabBarView
    }
    
    func bindViewModel() {
        
    }
}

