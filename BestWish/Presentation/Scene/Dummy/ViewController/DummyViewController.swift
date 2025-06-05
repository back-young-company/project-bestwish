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
}

