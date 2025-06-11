//
//  DummyViewController.swift
//  BestWish
//
//  Created by 이수현 on 6/3/25.
//

import UIKit
import RxSwift
import RxCocoa

class DummyViewController: UIViewController {
    
    private let dummyView = DummyView()
    private let viewModel: DummyViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: DummyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        if let key = Bundle.main.infoDictionary?["API_KEY"] as? String,
           let url = Bundle.main.infoDictionary?["SUPABASE_URL"] as? String {
            print("key: \(key)")
            print("url: \(url)")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = dummyView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        viewModel.action.onNext(.viewDidLoad(()))
        
        shortcutButtonTapped()
    }

    private func bindViewModel() {
        viewModel.state.data
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, dummyDisplay in
                owner.dummyView.configure(with: dummyDisplay)
            }.disposed(by: disposeBag)

        viewModel.state.error
            .bind { error in
                print("에러 얼럿 띄우기")
            }.disposed(by: disposeBag)
    }
    
    private func shortcutButtonTapped() {
        dummyView.shortcutButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                guard let sharedDefaults = UserDefaults(suiteName: "group.com.bycompany.bestwish") else { return }
                
                guard let urlString = sharedDefaults.string(forKey: "productURL") else { return }
                
                guard let url = URL(string: urlString) else {
                    print("❌ 저장된 상품 URL이 없습니다.")
                    return
                }

                UIApplication.shared.open(url, options: [:]) { success in
                    if success {
                        print("✅ 앱 전환 성공: \(url.absoluteString)")
                    } else {
                        print("❌ 앱 전환 실패: \(url.absoluteString)")
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}
