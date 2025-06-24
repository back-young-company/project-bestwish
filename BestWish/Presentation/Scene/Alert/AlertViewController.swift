//
//  AlertViewController.swift
//  BestWish
//
//  Created by 이수현 on 6/12/25.
//

import UIKit

import RxCocoa
import RxSwift

/// Custom Alert ViewController
final class AlertViewController: UIViewController {
    private let type: AlertView.AlertType
    private let alertView: AlertView
    private let disposeBag = DisposeBag()
    
    private var confirmAction: (() -> Void)? // 확인 버튼 액션 클로저

    init(type: AlertView.AlertType, action: (() -> Void)? = nil) {
        self.type = type
        alertView = AlertView(type: type)
        confirmAction = action
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = alertView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindView()
    }

    private func bindView() {
        // Alert 외부 영역 탭 제스처
        let tapGesture = UITapGestureRecognizer()
        tapGesture.delegate = self
        alertView.addGestureRecognizer(tapGesture)

        Observable.merge(
            tapGesture.rx.event.map { _ in },
            alertView.cancelButton.rx.tap.map { }
        ).bind(with: self) { owner, _ in
            owner.dismiss(animated: true)
        }.disposed(by: disposeBag)

        alertView.confirmButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.confirmAction?()
                owner.dismiss(animated: true)
            }.disposed(by: disposeBag)
    }
}

// MARK: - Gesture Delegate
extension AlertViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchLocation = touch.location(in: alertView)
        return !alertView.contentView.frame.contains(touchLocation)
    }
}
