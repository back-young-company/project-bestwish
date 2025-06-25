//
//  OnboardingView.swift
//  BestWish
//
//  Created by yimkeul on 6/7/25.
//

import Foundation
import UIKit
import SnapKit
import Then

final class OnboardingView: UIView {
    // MARK: - Properties

    // MARK: - UI Components

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

private extension OnboardingView {
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
    }
    // MARK: - Hierarchy Helper
    // subView 추가 메서드
    func setHierarchy() {
    }

    // MARK: - Layout Helper
    // 오토레이이아웃 설정 메서드
    func setConstraints() {
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

