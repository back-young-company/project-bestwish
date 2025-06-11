//
//  SceneDelegate.swift
//  BestWish
//
//  Created by 이수현 on 6/3/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)


        let service = DummyServiceImpl()
        let repository = DummyRepositoryImpl(service: service)
        let useCase = DummyUseCaseImpl(repository: repository)
        let vm = DummyViewModel(dummyUseCase: useCase)
        window?.rootViewController = TabBarViewController(viewControllers: [AVC(), CameraViewController(), CVC()])// DummyViewController(viewModel: vm)
        window?.makeKeyAndVisible()
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

final class CVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
    }
}
//----------------------------------
