//
//  OnboardingSecondView.swift
//  BestWish
//
//  Created by yimkeul on 6/12/25.
//

import UIKit
import SnapKit
import Then


final class OnboardingSecondView: UIView {

    // MARK: - UI Components
    private let header = OnboardingHeaderView(current: 2, total: 2,
                                              title: OnboardingText.secondTitle.value,
                                              desc: OnboardingText.secondDesc.value)
    private let stackView = VerticalStackView(spacing: 40)
    let profileImageView = UIImageView()
    let nicknameStackView = NicknameInputView()



    // MARK: - Initializer, Deinit, requiered
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(input: OnboardingDisplay) {
        profileImageView.image = UIImage(named: input.profileImageName)?.resize(to: CGSize(width: CGFloat(152).fitWidth, height: CGFloat(152).fitHeight))

    }

}

private extension OnboardingSecondView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setDelegate()
        setDataSource()
        setBindings()
    }

    func setAttributes() {
        self.backgroundColor = .gray0
        stackView.do {
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(
                top: 16,
                left: 20,
                bottom: 16,
                right: 20
            )
        }
        
        profileImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.layer.cornerRadius = CGFloat(152).fitWidth / 2
            $0.clipsToBounds = true
            $0.isUserInteractionEnabled = true
        }



    }

    func setHierarchy() {
        self.addSubviews(header, stackView)
        stackView.addArrangedSubviews(profileImageView, nicknameStackView)

    }

    func setConstraints() {
        header.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(CGFloat(38).fitHeight)
            $0.leading.trailing.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
        }

        profileImageView.snp.makeConstraints {
            $0.centerX.equalTo(stackView)
        }

    }

    func setDelegate() {
    }

    func setDataSource() {
    }

    func setBindings() {
    }

}

