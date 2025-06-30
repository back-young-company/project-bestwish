//
//  OnboardingViewController.swift
//  BestWish
//
//  Created by yimkeul on 6/30/25.
//

import UIKit

import RxSwift

/// 온보딩 View Controller
final class OnboardingViewController: UIViewController {
    private let viewModel: OnboardingViewModel
    private let onboardingView = OnboardingBottomSheetView()
    private let disposeBag = DisposeBag()

    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = onboardingView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingView.scrollView.delegate = self
        bindView()
        bindViewModel()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.action.onNext(.viewDidLayoutSubviews)
    }

    private func bindView() {
        // 다음 페이지 버튼 탭 → ViewModel에 액션 전달
        onboardingView.pagingButton.rx.tap
            .asDriver()
            .map { .didTapNextPage }
            .drive(viewModel.action)
            .disposed(by: disposeBag)

        // 닫기 버튼 탭 → 모달 해제
        onboardingView.closeButton.rx.tap
            .subscribe(with: self) {owner, _ in
                print("닫기")
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }

    private func bindViewModel() {
        viewModel.state.pages
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, pages in
                owner.onboardingView.configure(with: pages)
            }
            .disposed(by: disposeBag)

        viewModel.state.currentPage
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, page in
                owner.onboardingView.pageController.currentPage = page
                owner.onboardingView.scrollToPage(page)
            }
            .disposed(by: disposeBag)
    }
}


// MARK: - UIScrollViewDelegate
extension OnboardingViewController: UIScrollViewDelegate {

    // 뷰모델에 스크롤 종료 시점 전달
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        viewModel.action.onNext(.didScrollToPage(pageIndex))
    }
}
