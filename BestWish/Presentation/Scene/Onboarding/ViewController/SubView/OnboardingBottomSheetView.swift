//
//  OnboardingBottomSheetView.swift
//  BestWish
//
//  Created by yimkeul on 6/30/25.
//

import UIKit

import SnapKit
import Then

/// 온보딩 바텀 시트 화면
final class OnboardingBottomSheetView: UIView {

    // MARK: - Private Property
    private let _scrollView = UIScrollView()
    private let _headerButtonVStack = VerticalStackView()
    private let _closeButton = UIButton()
    private let _contentsHStack = HorizontalStackView()
    private let _pagingButtonVStackView = VerticalStackView()
    private let _pageController = UIPageControl()
    private let _pagingButton = AppButton(type: .next)

    // MARK: - Internal Property
    var scrollView: UIScrollView { _scrollView }
    var pageController: UIPageControl { _pageController }
    var pagingButton: AppButton { _pagingButton }
    var closeButton: UIButton { _closeButton }


    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(with pages: [OnboardingDataInfo]) {
        // 1) 기존에 있던 페이지 뷰들 제거
        _contentsHStack.arrangedSubviews
            .forEach {
            _contentsHStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        // 2) 페이지 수만큼 새 뷰 생성
        pages.forEach { info in
            let pageVStack = makePageStack(for: info)
            _contentsHStack.addArrangedSubviews(pageVStack)
        }

        // 3) 페이지 컨트롤 업데이트
        _pageController.numberOfPages = pages.count
        _pageController.currentPage = 0
    }

    func configureButton(currentPage: Int) {
        if currentPage == 4 {
            _pagingButton.changeButtonType(type: .complete)
        } else {
            _pagingButton.changeButtonType(type: .next)
        }
    }


    func scrollToPage(_ index: Int, animated: Bool = true) {
      let x = scrollView.bounds.width * CGFloat(index)
      scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: animated)
    }

}

// MARK: - private 메서드
private extension OnboardingBottomSheetView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        self.backgroundColor = .gray0

        _scrollView.do {
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.bounces = false
            $0.contentInsetAdjustmentBehavior = .scrollableAxes
        }

        _contentsHStack.do {
            $0.distribution = .fillEqually
        }

        _headerButtonVStack.do {
            $0.alignment = .trailing
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(
                top: .zero,
                left: 8,
                bottom: .zero,
                right: 8
            )
        }

        _closeButton.do {
            var config = UIButton.Configuration.plain()
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 17.5, weight: .regular)

            config.image = UIImage(systemName: "xmark")?.withConfiguration(symbolConfig)
            config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
            $0.configuration = config
            $0.tintColor = .gray900
        }


        _pageController.do {
            $0.numberOfPages = 5
            $0.currentPage = 0
            $0.hidesForSinglePage = false
            $0.pageIndicatorTintColor = .gray50
            $0.currentPageIndicatorTintColor = .primary300
        }

        _pagingButtonVStackView.do {
            $0.distribution = .equalSpacing
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(
                top: 20,
                left: 20,
                bottom: 12,
                right: 20
            )
        }
    }

    func setHierarchy() {
        self.addSubviews(_headerButtonVStack, _scrollView, _pagingButtonVStackView)
        _headerButtonVStack.addArrangedSubviews(_closeButton)
        _scrollView.addSubview(_contentsHStack)
        _pagingButtonVStackView.addArrangedSubviews(_pageController, _pagingButton)
    }

    func setConstraints() {
        _headerButtonVStack.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }

        _scrollView.snp.makeConstraints {
            $0.top.equalTo(_headerButtonVStack.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }

        _contentsHStack.snp.makeConstraints {
            $0.edges.equalTo(_scrollView.contentLayoutGuide)
            $0.width.equalTo(_scrollView.frameLayoutGuide).multipliedBy(5)
            $0.height.equalTo(_scrollView.frameLayoutGuide)
        }

        _pagingButtonVStackView.snp.makeConstraints {
            $0.top.equalTo(_scrollView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }

        _pagingButton.snp.makeConstraints {
            $0.height.equalTo(CGFloat(53).fitHeight)
        }
    }
}


// MARK: - Paging 내부 View 구현
extension OnboardingBottomSheetView {
    private func makePageStack(for info: OnboardingDataInfo) -> UIStackView {
        let _pageVStack = VerticalStackView(spacing: 15)
        let _textVStack = VerticalStackView(spacing: 12)
        let _titleLabel = UILabel()
        let _descLabel = UILabel()
        let _imageView = UIImageView()


        _textVStack.do {
            $0.alignment = .center
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(
                top: 16,
                left: 20,
                bottom: 16,
                right: 20
            )
        }

        _titleLabel.do {
            $0.text = info.title.value
            $0.textAlignment = .center
            $0.font = .font(.pretendardBold, ofSize: 24)
            $0.textColor = .gray900
        }

        _descLabel.do {
            $0.text = info.desc.value
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            $0.textAlignment = .center
            $0.font = .font(.pretendardMedium, ofSize: 14)
            $0.textColor = .gray600
        }

        _imageView.do {
            $0.image = UIImage(named: info.image.value)
            $0.contentMode = .scaleAspectFit
        }

        _textVStack.addArrangedSubviews(_titleLabel, _descLabel)
        _pageVStack.addArrangedSubviews(_textVStack, _imageView)

        _titleLabel.snp.makeConstraints {
            $0.height.equalTo(CGFloat(29).fitHeight)
        }

        _descLabel.snp.makeConstraints {
            $0.height.equalTo(CGFloat(34).fitHeight)
        }

        _imageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(
                CGFloat.isSESize ? CGFloat(350).fitHeight : CGFloat(411).fitHeight
            )
        }

        return _pageVStack
    }
}
