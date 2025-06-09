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
        self.viewControllers = viewControllers
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
    
    /// 뷰 바인딩
    private func bind() {
        
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
    
    /// 탭바 아이템 변경 시 호출되는 메서드
    private func changedTabBarItem(_ tabBarMode: TabBarMode, _ floatingMode: FloatingMode) {
        switch floatingMode {
        case .home:
            // 탭바 아이템 상태 이미지 변경
            tabBarView.getLeftItemButton.setImage(tabBarMode.homeModeImage?.left, for: .normal)
            tabBarView.getRightItemButton.setImage(tabBarMode.homeModeImage?.right, for: .normal)
            
            changeChildView(tabBarMode.rawValue) // 홈 모드일 때는 탭바의 역할을 수행
            homeToCamera(tabBarMode) // 이미지 변경 및 모드 변경 이벤트 방출
        case .camera: print("카메라 모드로 변경")
        }
    }
    
    /// 홈 모드에서 카메라 모드로 변경
    private func homeToCamera(_ tabBarMode: TabBarMode) {
        guard let center = tabBarMode.homeModeImage?.center else { return }
        tabBarView.getCenterItemButton.setImage(center, for: .normal)
        tabBarView.getLeftItemButton.setImage(tabBarMode.cameraModeHilightImage?.left, for: .highlighted)
        tabBarView.getCenterItemButton.setImage(tabBarMode.cameraModeHilightImage?.center, for: .highlighted)
        tabBarView.getRightItemButton.setImage(tabBarMode.cameraModeHilightImage?.right, for: .highlighted)
        
        self.floatingMode.accept(.camera)
    }
    
    /// 탭바 선택 시 뷰 변경
    private func changeChildView(_ index: Int) {
        // 자식 VC 교체
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
        view.insertSubview(childVC.view, at: 0) // ← 부모 탭바보다 아래에 배치
        childVC.didMove(toParent: self)
    }
}

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
