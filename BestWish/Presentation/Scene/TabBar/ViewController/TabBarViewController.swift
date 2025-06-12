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
    
    private let viewControllers:[UIViewController]
    private let disposeBag = DisposeBag()
    private let tabBarView = TabBarView()
    private let tabBarMode = BehaviorRelay<TabBarMode>(value: .left)
    private let floatingMode = BehaviorRelay<FloatingMode>(value: .home)
    
    private var hasEnteredCameraMode = false
    
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
        // 탭바 왼쪽 버튼 터치 시
        tabBarView.getLeftItemButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.tabBarMode.accept(.left)
            }
            .disposed(by: disposeBag)
        
        // 플로팅 버튼 터치 시
        tabBarView.getCenterItemButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.tabBarMode.accept(.center)
            }
            .disposed(by: disposeBag)
        
        // 탭바 오른쪽 버튼 터치 시
        tabBarView.getRightItemButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.tabBarMode.accept(.right)
            }
            .disposed(by: disposeBag)
        
        // 탭바 아이템 및 플로팅 모드에 따른 바인딩
        Observable.combineLatest(tabBarMode, floatingMode)
            .observe(on: MainScheduler.asyncInstance)
            .debounce(.milliseconds(10), scheduler: MainScheduler.instance)         // 카메라 모드에서 홈으로 넘어갈 떄 .camera, .left를 동시에 방출하기 때문에 이 경우에만 하나로 묶어서 구독하기 위함
            .subscribe(with: self) { owner, input in
                let (tabBarMode, floatingMode) = input
                owner.changedTabBarItem(tabBarMode, floatingMode)
            }
            .disposed(by: disposeBag)
        
        // 카메라 모드일 경우 카메라 헤더의 홈 버튼을 터치했을 때의 이벤트 처리
        guard let nav = viewControllers[TabBarMode.center.rawValue] as? UINavigationController,
              let cameraVC = nav.viewControllers.first as? CameraViewController else { return }
        cameraVC.getHeaderHomeButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.floatingMode.accept(.home)
                owner.tabBarMode.accept(.left)
                owner.hasEnteredCameraMode = false
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - UI 업데이트
private extension TabBarViewController {
    
    /// 모드에 따른 탭바 이미지 업데이트
    private func updateTabBarImages(for mode: TabBarMode, using floating: FloatingMode) {
        let imageSet = TabBarImageSet(mode: mode, floating: floating)
        tabBarView.getLeftItemButton.setImage(imageSet.left.normal, for: .normal)
        tabBarView.getCenterItemButton.setImage(imageSet.center.normal, for: .normal)
        tabBarView.getRightItemButton.setImage(imageSet.right.normal, for: .normal)

        tabBarView.getLeftItemButton.setImage(imageSet.left.highlight, for: .highlighted)
        tabBarView.getCenterItemButton.setImage(imageSet.center.highlight, for: .highlighted)
        tabBarView.getRightItemButton.setImage(imageSet.right.highlight, for: .highlighted)
    }
    
    /// 탭바 아이템 / 플로팅 버튼 선택 시 이벤트
    private func changedTabBarItem(_ mode: TabBarMode, _ floating: FloatingMode) {
        updateTabBarImages(for: mode, using: floating)

        switch (mode, floating) {
        case (.left, .home), (.right, .home):       // 탭바 아이템 선택 시 해당 뷰 컨트롤러로 변경
            changeChildView(mode.rawValue)
        case (.center, .home):                      // 카메라 모드로 진입 후 카메라 뷰 컨트롤러로 변경
            floatingMode.accept(.camera)
            changeChildView(mode.rawValue)
        case (.center, .camera):                    // 홈 모드에서 카메라 모드로 처음 변경될 시 촬영 기능이 실행됨을 방지하기 위해 Bool 변수 지정
            if hasEnteredCameraMode {
                guard let nav = viewControllers[TabBarMode.center.rawValue] as? UINavigationController,
                      let cameraVC = nav.viewControllers.first as? CameraViewController else { return }
                cameraVC.didTapTakePhoto()
            } else {
                hasEnteredCameraMode = true
            }
        case (.left, .camera):                      // 사진첩 선택 시
            presentImagePicker()
        case (.right, .camera):                     // 화면 전환 선택 시
            guard let nav = viewControllers[TabBarMode.center.rawValue] as? UINavigationController,
                  let cameraVC = nav.viewControllers.first as? CameraViewController else { return }
            cameraVC.switchCamera()
        }
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

// MARK: - 이미지 피커 관련
extension TabBarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    /// 이미지 피커 뷰 열기
    func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    /// 이미지 선택 시
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else { return }
        guard let nav = viewControllers[TabBarMode.center.rawValue] as? UINavigationController,
              let cameraVC = nav.viewControllers.first as? CameraViewController else { return }
        cameraVC.presentImageCropper(with: image)
    }
}
