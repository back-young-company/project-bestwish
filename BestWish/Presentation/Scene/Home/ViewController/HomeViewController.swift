//
//  HomeViewController.swift
//  BestWish
//
//  Created by 이수현 on 6/3/25.
//

import UIKit

class HomeViewController: UIViewController {
    private let homeView = HomeView()

    override func loadView() {
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

