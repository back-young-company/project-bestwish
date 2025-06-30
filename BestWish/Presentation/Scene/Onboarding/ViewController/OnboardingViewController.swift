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
        viewModel.action.onNext(.viewDidLoad)
    }

    private func bindView() {

        onboardingView.pagingButton.rx.tap
            .withLatestFrom(viewModel.state.currentPage)
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, page in
            let lastIndex = OnboardingData.allCases.count - 1
            if page == lastIndex {
                // 마지막 페이지라면 닫기
                owner.dismiss(animated: true)
            } else {
                // 아니면 다음 페이지로
                owner.viewModel.action.onNext(.didTapNextPage)
            }
        }
            .disposed(by: disposeBag)

        // 닫기 버튼 탭 → 모달 해제
        onboardingView.closeButton.rx.tap
            .subscribe(with: self) { owner, _ in
            owner.dismiss(animated: true)
        }
            .disposed(by: disposeBag)
    }

    private func bindViewModel() {
        viewModel.state.pages
            .take(1)
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
            owner.onboardingView.configureButton(currentPage: page)
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
