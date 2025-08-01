//
//  UIViewController+Extension.swift
//  BestWish
//
//  Created by 이수현 on 6/9/25.
//

import BestWishDomain
import UIKit

extension UIViewController {

    /// 내비게이션 바 위치
    enum Alignment {
        case left
        case center
    }

    /// 내비게이션 바 설정
    func setNavigationBar(alignment: UIViewController.Alignment, title: String) {
        self.navigationController?.navigationBar.isHidden = false
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
            label.textColor = .gray900
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

    func showDeepLinkAlert(_ link: String) {
        let alertController = UIAlertController(
            title: "해당 앱이 설치되어 있지 않습니다.",
            message: "원하시는 실행 방법을 선택해 주세요.",
            preferredStyle: .alert
        )

        guard let platformEntity = PlatformEntity(text: link) else { return }

        let webAction = UIAlertAction(title: "웹으로 이동", style: .default) { _ in
            UIApplication.shared.open(URL(string: platformEntity.platformWebLink)!)
        }

        let appStoreAction = UIAlertAction(title: "앱스토어로 이동", style: .default) { _ in
            UIApplication.shared.open(URL(string: platformEntity.platformAppStoreLink)!)
        }

        alertController.addAction(webAction)
        alertController.addAction(appStoreAction)

        present(alertController, animated: true)
    }
}
