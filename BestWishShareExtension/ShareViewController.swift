//
//  ShareViewController.swift
//  BestWishShareExtension
//
//  Created by 백래훈 on 6/9/25.
//

import UIKit
import Social

import Kingfisher
import RxSwift
import SnapKit
import Then

class ShareViewController: UIViewController {

    private let productImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.borderColor = UIColor.systemGray6.cgColor
        $0.layer.borderWidth = 0.5
        $0.clipsToBounds = true
    }
    
    private let brandTitle = UILabel().then {
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 11, weight: .bold)
    }
    
    private let productTitle = UILabel().then {
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 2
    }
    
    private let productDiscount = UILabel().then {
        $0.textColor = .systemRed
        $0.font = .systemFont(ofSize: 13, weight: .bold)
        $0.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    private let productPrice = UILabel().then {
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 13, weight: .bold)
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    private let hStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .leading
        $0.distribution = .fill
    }
    
    private let vStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    private let containerView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let shareView = ShareView()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
//        extractSharedContent()
    }
    
    private func configureView() {
        self.view.backgroundColor = .systemBackground
        
        [productImage, vStackView].forEach {
            self.view.addSubview($0)
        }
        
        [brandTitle, productTitle, hStackView].forEach {
            self.vStackView.addArrangedSubview($0)
        }
        
        [productDiscount, productPrice].forEach {
            self.hStackView.addArrangedSubview($0)
        }
    }
    
    private func configureView2() {
        self.view.addSubview(containerView)
        containerView.addSubview(productImage)
    }
    
    private func setConstraints2() {
        containerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        productImage.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
//    private func setConstraints() {
//        productImage.snp.makeConstraints {
//            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
//            $0.centerX.equalToSuperview()
//            $0.size.equalTo(150)
//        }
//        
//        vStackView.snp.makeConstraints {
//            $0.top.equalTo(productImage.snp.bottom).offset(4)
//            $0.centerX.equalTo(productImage.snp.centerX)
//            $0.width.equalTo(productImage.snp.width)
//        }
//    }
    
    // MARK: - 아래의 메서드들은 ViewModel로 이전
    // 📥 공유된 콘텐츠를 추출하여 각 provider에 대해 처리
    private func extractSharedContent() {
        guard let extensionItems = extensionContext?.inputItems as? [NSExtensionItem] else { return }

        for item in extensionItems {
            guard let attachments = item.attachments else { continue }
            for provider in attachments {
                handleSharedItem(from: provider)
            }
        }
    }

    // 🔍 provider의 타입에 따라 URL 또는 텍스트로 처리 분기
    private func handleSharedItem(from provider: NSItemProvider) {
        if provider.hasItemConformingToTypeIdentifier("public.url") {
            provider.loadItem(forTypeIdentifier: "public.url", options: nil) { [weak self] item, _ in
                guard let self, let url = item as? URL else { return }
                self.handleSharedText(url.absoluteString)
            }
        } else if provider.hasItemConformingToTypeIdentifier("public.text") {
            provider.loadItem(forTypeIdentifier: "public.text", options: nil) { [weak self] item, _ in
                guard let self, let text = item as? String else { return }
                self.handleSharedText(text)
            }
        }
    }
    
    private func handleSharedText(_ text: String) {
        ShareExtensionService.shared
            .fetchPlatformMetadata(from: text)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] originalUrl, metadata in
                guard let self else { return }
                
                self.productImage.kf.setImage(with: URL(string: metadata.imageURL ?? ""))
                self.brandTitle.text = metadata.brandName
                self.productTitle.text = metadata.productName
                self.productDiscount.text = "\(metadata.discountRate ?? "0")%"
                self.productPrice.text = "\(metadata.price ?? "-")원"
                
                print("저장되는 상품 url: \(metadata.productURL?.absoluteString)")
                let sharedDefaults = UserDefaults(suiteName: "group.com.bycompany.bestwish")
                sharedDefaults?.setValue(metadata.productURL?.absoluteString, forKey: "productURL")
            }, onFailure: { error in
                print("❌ Metadata fetch error: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}

private extension ShareViewController {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        shareView.do {
            $0.backgroundColor = .white
        }
    }

    func setHierarchy() {
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
