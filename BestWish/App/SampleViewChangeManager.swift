//
//  SampleViewChangeManager.swift
//  BestWish
//
//  Created by yimkeul on 6/13/25.
//

import UIKit

final class SampleViewChangeManager {
    static let shared = SampleViewChangeManager()
    private init() {}

    func goOnboardingView() {
        DispatchQueue.main.async {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let delegate = scene.delegate as? SceneDelegate {
                delegate.showOnboardingView()
            }
        }
    }

    func goLoginView() {
        DispatchQueue.main.async {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let delegate = scene.delegate as? SceneDelegate {
                delegate.showLoginView()
            }
        }
    }

    func goMainView() {
        DispatchQueue.main.async {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let delegate = scene.delegate as? SceneDelegate {
                delegate.showMainView()
            }
        }
    }
}

