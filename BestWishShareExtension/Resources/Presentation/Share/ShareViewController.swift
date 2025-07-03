//
//  ShareViewController.swift
//  BestWishShareExtension
//
//  Created by 백래훈 on 6/9/25.
//

import BestWishDomain
import BestWishData
import UIKit
import Social

internal import RxSwift
internal import RxCocoa

/// 공유 View Controller
final class ShareViewController: UIViewController {

    // MARK: - Private Property
    private let shareViewModel = ShareViewModel(
        wishListUseCase: WishListUseCaseImpl(
            repository: WishListRepositoryImpl(
                manager: SupabaseManager(),
                userInfoManager: SupabaseUserInfoManagerImpl()
            )
        ),
        productSyncUseCase: ProductSyncUseCaseImpl(
            repository: ProductSyncRepositoryImpl(
                manager: ProductSyncManager()
            )
        )
    )
    private let shareView = ShareView()
    private let disposeBag = DisposeBag()

    override func loadView() {
        view = shareView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        bindActions()

        extractSharedContent()
    }

    private func bindViewModel() {
        shareViewModel.state.completed
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, _ in
                owner.shareView.successConfigure()

                let sharedDefaults = UserDefaults(suiteName: "group.com.bycompany.bestwish")
                sharedDefaults?.set(true, forKey: "AddProduct")
                sharedDefaults?.synchronize() // (Optional) 최신화 강제
            }
            .disposed(by: disposeBag)

        shareViewModel.state.error
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, error in
                owner.shareView.failureConfigure()
            }
            .disposed(by: disposeBag)
    }

    private func bindActions() {
        // 백그라운드 탭 시 자동으로 공유 화면 내리기
        let tapGesture = UITapGestureRecognizer()
        tapGesture.cancelsTouchesInView = true
        shareView.backgroundView.addGestureRecognizer(tapGesture)

        tapGesture.rx.event
            .bind(with: self) { owner, _ in
                print(#function)
                owner.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
            }.disposed(by: disposeBag)

        // 바로가기 버튼 탭 시 앱 복귀
        shareView.shortcutButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.openMainApp()
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - private 메서드
private extension ShareViewController {
    /// 공유된 콘텐츠를 추출하여 각 provider에 대해 처리
    func extractSharedContent() {
        guard let extensionItems = extensionContext?.inputItems as? [NSExtensionItem] else { return }

        for item in extensionItems {
            guard let attachments = item.attachments else { continue }
            for provider in attachments {
                self.shareViewModel.action.onNext(.addProduct(provider))
            }
        }
    }

    /// Best Wish 앱 딥링크 호출
    func openMainApp() {
        if let url = URL(string: "bestwish://home") {
            if openURLScheme(url) {
                NSLog("\(Self.self) ✅ URL Scheme open 성공")
            } else {
                NSLog("\(Self.self) ❌ URL Scheme open 실패")
            }
        } else {
            NSLog("\(#function) 잘못된 URL")
        }

        extensionContext?.completeRequest(returningItems: nil)
    }

    /// UIApplication 접근 후 링크 오픈
    func openURLScheme(_ url: URL) -> Bool {
        // Share Extension에서는 UIApplication.shared를 사용할 수 없기 때문에 responder chain을 따라
        // UIApplication 인스턴스에 접근
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                application.open(url, options: [:], completionHandler: nil)
                return true
            }
            // UIApplication이 아니면, 다음 응답자로 이동
            responder = responder?.next
        }
        return false
    }
}
