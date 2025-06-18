//
//  GenderSelectionView.swift
//  BestWish
//
//  Created by yimkeul on 6/11/25.
//


import UIKit
import RxSwift
import RxCocoa

enum Gender: Int, CaseIterable {
    case male, female, nothing
    var value: String {
        switch self {
        case .male: return "남자"
        case .female: return "여자"
        case .nothing: return "선택 안 함"
        }
    }
}

final class GenderSelectionView: UIView {

    // 외부에서 선택 상태를 구독할 수 있도록 Relay 공개
    let selectedGender = BehaviorRelay<Gender?>(value: nil)
    private let disposeBag = DisposeBag()

    private let rootVStackView = VerticalStackView(spacing: 8)
    private let genderLabel = InfoLabel(title: "성별")
    private let radioHStackView = HorizontalStackView(spacing: 24)
    private let maleButton = RadioButton(title: Gender.male.value)
    private let femaleButton = RadioButton(title: Gender.female.value)
    private let nothingButton = RadioButton(title: Gender.nothing.value)

    init() {
        super.init(frame: .zero)
        setView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(genderIndex: Int?) {
        guard let genderIndex else { return }
        selectedGender.accept(Gender(rawValue: genderIndex))
    }
}
extension GenderSelectionView {

    private func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
        bindUI()
    }

    func setAttributes() {
        rootVStackView.do {
            $0.alignment = .leading
        }

        radioHStackView.do {
            $0.distribution = .fillProportionally
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(
                top: 12,
                left: 0,
                bottom: 12,
                right: 0
            )
        }
    }

    func setHierarchy() {
        self.addSubview(rootVStackView)
        self.rootVStackView.addArrangedSubviews(genderLabel, radioHStackView)
        self.radioHStackView.addArrangedSubviews(maleButton, femaleButton, nothingButton)
    }

    func setConstraints() {
        rootVStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func bindUI() {
        // 버튼 탭 → selectedGender 갱신
        maleButton.rx.tap
            .map { Gender.male }
            .bind(to: selectedGender)
            .disposed(by: disposeBag)

        femaleButton.rx.tap
            .map { Gender.female }
            .bind(to: selectedGender)
            .disposed(by: disposeBag)

        nothingButton.rx.tap
            .map { Gender.nothing }
            .bind(to: selectedGender)
            .disposed(by: disposeBag)

        // selectedGender 구독 → 각 버튼 isSelected 업데이트
        selectedGender
            .subscribe(with: self) { owner, gender in
            owner.maleButton.isSelected = (gender == .male)
            owner.femaleButton.isSelected = (gender == .female)
            owner.nothingButton.isSelected = (gender == .nothing)
        }
            .disposed(by: disposeBag)
    }
}
