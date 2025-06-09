//
//  TabBarController.swift
//  BestWish
//
//  Created by Quarang on 6/5/25.
//

import UIKit
import RxSwift
import RxCocoa

/// 커스텀 탭바  클래스
///
/// ```swift
/// private let tabBar = TabBarViewController(viewControllers: [AVC(), BVC(), CVC()])
/// ```

// MARK: - 메인 탭바 컨트롤러
final class TabBarViewController: UIViewController {
    
    /// 플로팅 버튼 모드 홈/카메라
    private enum FloatingMode {
        case home
        case camera
    }
    
    /// 탭바 모드 - 좌/중/우
    private enum TabBarMode: Int {
        case left = 0
        case center = 1
        case right = 2
        
        /// 홈 모드일 때 탭 상태에 따라 탭바 이미지 변경
        var homeModeImage: (left: UIImage?, center: UIImage?, right: UIImage?)? {
            switch self {
            case .left:
                return (UIImage(named: "home_se1"), nil, UIImage(named: "home_de3"))
            case .center:
                return (UIImage(named: "camera_de1"), UIImage(named: "camera_de2"), UIImage(named: "camera_de3"))
            case .right:
                return (UIImage(named: "home_de1"), nil, UIImage(named: "home_se3"))
            }
        }
        
        /// 카메라 모드일 때 하이라이트 이미지 변경
        var cameraModeHilightImage: (left: UIImage?, center: UIImage?, right: UIImage?)? {
            return (UIImage(named: "camera_se1"), UIImage(named: "camera_se2"), UIImage(named: "camera_se3"))
        }
    }

    private let viewControllers:[UIViewController]
    private let disposeBag = DisposeBag()
    private let tabBarView = TabBarView()
    private let tabBarMode = BehaviorRelay<TabBarMode>(value: .left)
    private let floatingMode = BehaviorRelay<FloatingMode>(value: .home)
    
    init(viewControllers: [UIViewController]) {
        self.viewControllers = Array(viewControllers.prefix(3))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func loadView() {
        view = tabBarView
    }
}

// MARK: - Binding
private extension TabBarViewController {
    func bind() {
        tabBarView.getLeftItemButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.tabBarMode.accept(.left)
            }
            .disposed(by: disposeBag)
        
        tabBarView.getCenterItemButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.tabBarMode.accept(.center)
            }
            .disposed(by: disposeBag)
        
        tabBarView.getRightItemButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.tabBarMode.accept(.right)
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(tabBarMode, floatingMode)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(with: self) { owner, input in
                let (tabBarMode, floatingMode) = input
                owner.changedTabBarItem(tabBarMode, floatingMode)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - UI 업데이트
private extension TabBarViewController {
    private func changedTabBarItem(_ tabBarMode: TabBarMode, _ floatingMode: FloatingMode) {
        switch floatingMode {
        case .home:
            tabBarView.getLeftItemButton.setImage(tabBarMode.homeModeImage?.left, for: .normal)
            tabBarView.getRightItemButton.setImage(tabBarMode.homeModeImage?.right, for: .normal)
            changeChildView(tabBarMode.rawValue)
            homeToCamera(tabBarMode)
        case .camera:
            print("카메라 모드로 변경")
        }
    }
    
    private func homeToCamera(_ tabBarMode: TabBarMode) {
        guard let center = tabBarMode.homeModeImage?.center else { return }
        tabBarView.getCenterItemButton.setImage(center, for: .normal)
        tabBarView.getLeftItemButton.setImage(tabBarMode.cameraModeHilightImage?.left, for: .highlighted)
        tabBarView.getCenterItemButton.setImage(tabBarMode.cameraModeHilightImage?.center, for: .highlighted)
        tabBarView.getRightItemButton.setImage(tabBarMode.cameraModeHilightImage?.right, for: .highlighted)
        
        self.floatingMode.accept(.camera)
    }
}

// MARK: - 자식 VC 관리
private extension TabBarViewController {
    func changeChildView(_ index: Int) {
        
        guard viewControllers.count == 3 else {
            print("탭바 아이템은 반드시 3개가 존재해야 합니다.")
            return
        }
        children.forEach {
            $0.willMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }

        let childVC = viewControllers[index]
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height - (UIScreen.main.bounds.height < 700 ? 60 : 90)
        childVC.view.frame = CGRect(x: 0, y: 0, width: width, height: height)

        addChild(childVC)
        view.insertSubview(childVC.view, at: 0)
        childVC.didMove(toParent: self)
    }
}

// 나중에 지울 코드
//----------------------------------
final class AVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
    }
}

final class BVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
    }
}

final class CVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
    }
}
//----------------------------------
