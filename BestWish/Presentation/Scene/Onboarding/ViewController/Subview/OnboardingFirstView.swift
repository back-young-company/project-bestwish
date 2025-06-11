//
//  OnboardingFirstView.swift
//  BestWish
//
//  Created by yimkeul on 6/11/25.
//

import UIKit
import SnapKit
import Then

final class OnboardingFirstView: UIView {

    // MARK: - UI Components
    private let header = OnboardingHeaderView(current: 1, total: 2, title: OnboardingText.firstTitle.value, desc: OnboardingText.firstDesc.value)
    let genderSelection = GenderSelectionView()


    // MARK: - Initializer, Deinit, requiered
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

}

private extension OnboardingFirstView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setDelegate()
        setDataSource()
        setBindings()
    }

    // MARK: - Attirbute Helper
    // View에 대한 속성 설정 메서드
    func setAttributes() {
        self.backgroundColor = .gray0
    }
    // MARK: - Hierarchy Helper
    // subView 추가 메서드
    func setHierarchy() {
        self.addSubviews(header,genderSelection)
    }

    // MARK: - Layout Helper
    // 오토레이이아웃 설정 메서드
    func setConstraints() {
        header.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(CGFloat(38).fitHeight)
            $0.leading.trailing.equalToSuperview()
        }

        genderSelection.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview()
        }

    }

    // MARK: - Delegate Helper
    // 딜리게이트 설정
    func setDelegate() {
    }

    // MARK: - DataSource Helper
    // 데이터 소스 설정
    func setDataSource() {
    }

    // MARK: - Binding Helper
    func setBindings() {
    }
}

