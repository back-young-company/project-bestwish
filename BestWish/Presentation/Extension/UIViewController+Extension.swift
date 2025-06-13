//
//  UIViewController+Extension.swift
//  BestWish
//
//  Created by 이수현 on 6/9/25.
//

import UIKit

extension UIViewController {
    enum Alignment {
        case left
        case center
    }

    func setNavigationBar(alignment: UIViewController.Alignment, title: String) {
        self.navigationController?.navigationBar.tintColor = .gray900
        self.navigationItem.backButtonDisplayMode = .minimal
        let backImage = UIImage(systemName: "chevron.backward")?
            .withAlignmentRectInsets(.init(top: 0, left: -8, bottom: 0, right: 0))

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)

        navigationController?.navigationBar.standardAppearance = appearance

        switch alignment {
        case .left:
            let label = UILabel()
            label.text = title
            label.textColor = .black
            label.font = .font(.pretendardBold, ofSize: 18)
            let leftBarItem = UIBarButtonItem(customView: label)
            self.navigationItem.setLeftBarButton(leftBarItem, animated: true)
        case .center:
            self.title = title
        }
    }

    func hidesTabBar() {
        guard let navigationController,
              let tabBarController = navigationController.parent
                as? TabBarViewController else {
            return
        }
        tabBarController.setTabBarHidden(true)
    }

    func showTabBar() {
        guard let navigationController,
              let tabBarController = navigationController.parent
                as? TabBarViewController else {
            return
        }
        tabBarController.setTabBarHidden(false)
    }
}
