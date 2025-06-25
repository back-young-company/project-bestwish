//
//  ShareViewController.swift
//  BestWishShareExtension
//
//  Created by 백래훈 on 6/9/25.
//

import UIKit
import Social

import Supabase
import RxSwift
import RxCocoa
import SnapKit
import Then

/// 공유 View Controller
final class ShareViewController: UIViewController {

    // MARK: - Private Property
    private let shareViewModel = ShareViewModel(
        wishListUseCase: WishListUseCaseImpl(
            repository: WishListRepositoryImpl(
                manager: SupabaseManager(),
                userInfoManager: SupabaseUserInfoManager()
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

//    init(shareViewModel: ShareViewModel) {
//        self.shareViewModel = shareViewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setView()
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
        shareView.shortcutButton.rx.tap
            .bind(with: self) { owner, _ in
                if let url = URL(string: "bestwish://open") {
                    owner.extensionContext?.completeRequest(returningItems: [], completionHandler: { _ in
                        // 딥링크는 completeRequest 이후 호출해야 효과가 있음
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            _ = owner.extensionContext?.open(url, completionHandler: nil)
                        }
                    })
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - ShareViewController 설정
private extension ShareViewController {
    func setView() {
        setHierarchy()
        setConstraints()
    }

    func setHierarchy() {
        self.view.backgroundColor = .clear
        self.view.addSubview(shareView)
    }

    func setConstraints() {
        shareView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(300)
        }
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
}
