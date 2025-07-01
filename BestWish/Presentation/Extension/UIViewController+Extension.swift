//
//  UIViewController+Extension.swift
//  BestWish
//
//  Created by 이수현 on 6/9/25.
//

import UIKit

extension UIViewController {

    /// 내비게이션 바 위치
    enum Alignment {
        case left
        case center
    }

    /// 내비게이션 바 설정
    func setNavigationBar(alignment: UIViewController.Alignment, title: String) {
        self.navigationController?.navigationBar.tintColor = .gray900
        self.navigationItem.backButtonDisplayMode = .minimal
        let backImage = UIImage(systemName: "chevron.backward")?
            .withAlignmentRectInsets(.init(top: 0, left: -8, bottom: 0, right: 0))

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        appearance.titleTextAttributes = [
            .font: UIFont.font(.pretendardBold, ofSize: 20),
            .foregroundColor: UIColor.gray900 ?? .black
        ]
        appearance.shadowColor = .clear

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        switch alignment {
        case .left:
            let label = UILabel()
            label.text = title
            label.textColor = .black
            label.font = .font(.pretendardBold, ofSize: 20)
            let leftBarItem = UIBarButtonItem(customView: label)
            self.navigationItem.setLeftBarButton(leftBarItem, animated: true)
        case .center:
            self.title = title
        }
    }

    /// 탭 바 숨기기
    func hidesTabBar() {
        guard let navigationController,
              let tabBarController = navigationController.parent
                as? TabBarViewController else {
            return
        }
        tabBarController.setTabBarHidden(true)
    }

    /// 탭 바 나타내기
    func showTabBar() {
        guard let navigationController,
              let tabBarController = navigationController.parent
                as? TabBarViewController else {
            return
        }
        tabBarController.setTabBarHidden(false)
    }

    /// 얼럿 띄우기
    func showBasicAlert(title: String, message: String?) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(confirmAction)
        present(alertController, animated: true)
    }
}
