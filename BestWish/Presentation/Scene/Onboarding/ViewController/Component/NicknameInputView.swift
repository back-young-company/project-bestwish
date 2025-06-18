//
//  NicknameInputView.swift
//  BestWish
//
//  Created by yimkeul on 6/12/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class NicknameInputView: UIView {

    private let disposeBag = DisposeBag()

    private let rootVStackView = VerticalStackView(spacing: 12)
    private let nicknameLabel = InfoLabel(title: "닉네임")
    let textField = UITextField()
    let cautionLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

}

private extension NicknameInputView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setBindings()
    }

    func setAttributes() {
        textField.do {
            $0.font = .font(.pretendardMedium, ofSize: 16)
            $0.backgroundColor = .gray0
            $0.layer.borderWidth = 1.5
            $0.layer.borderColor = UIColor.gray200?.cgColor
            $0.layer.cornerRadius = 8
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
            $0.leftViewMode = .always
        }

        cautionLabel.do {
            $0.text = OnboardingText.secondCaution.value
            $0.font = .font(.pretendardMedium, ofSize: 12)
            $0.textColor = .gray200
        }
    }

    func setHierarchy() {
        self.addSubview(rootVStackView)
        rootVStackView.addArrangedSubviews(nicknameLabel, textField, cautionLabel)
    }

    func setConstraints() {
        rootVStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        nicknameLabel.snp.makeConstraints {
            $0.height.equalTo(17)
        }

        cautionLabel.snp.makeConstraints {
            $0.height.equalTo(14)
        }

        textField.snp.makeConstraints {
            $0.height.equalTo(48)
        }
    }

    func setBindings() {
        // 편집 시작
        textField.rx.controlEvent(.editingDidBegin)
            .subscribe(with: self) { owner, _ in
            owner.textField.layer.borderColor = UIColor.primary300?.cgColor
        }
            .disposed(by: disposeBag)
    }
}

