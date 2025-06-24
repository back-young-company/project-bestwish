//
//  DummyCoordinator.swift
//  BestWish
//
//  Created by yimkeul on 6/13/25.
//

import UIKit

final class DummyCoordinator {

    func showOnboardingView() {
        DispatchQueue.main.async {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let delegate = scene.delegate as? SceneDelegate {
                delegate.showOnboardingView()
            }
        }
    }

    func showLoginView() {
        DispatchQueue.main.async {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let delegate = scene.delegate as? SceneDelegate {
                delegate.showLoginView()
            }
        }
    }

    func showMainView() {
        DispatchQueue.main.async {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let delegate = scene.delegate as? SceneDelegate {
                delegate.showMainView()
            }
        }
    }
}

