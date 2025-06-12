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

    private let nicknameStackView = VerticalStackView(spacing: 12)
    private let nicknameLabel = InfoLabel(title: "닉네임")
    let textField = PaddingTextField(top: 14.5, left: 12, bottom: 14.5, right: 12)
    let cautionLabel = UILabel()

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
        }

        cautionLabel.do {
            $0.text = OnboardingText.secondCaution.value
            $0.font = .font(.pretendardMedium, ofSize: 12)
            $0.textColor = .gray200
        }
    }

    func setHierarchy() {
        self.addSubview(nicknameStackView)
        nicknameStackView.addArrangedSubviews(nicknameLabel, textField, cautionLabel)
    }

    func setConstraints() {
        nicknameStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        textField.snp.makeConstraints {
            $0.height.equalTo(CGFloat(48).fitHeight)
        }
    }

    func setBindings() {
        // 편집 시작
        textField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self] in
            self?.textField.layer.borderColor = UIColor.primary300?.cgColor
        })
            .disposed(by: disposeBag)

        // 텍스트가 바뀔 때마다 유효성 검사
        // TODO: 여기서 이벤트를 넘겨줘서 ViewController에서 처리하도록 수정해보기
//        textField.rx.text.orEmpty
//            .skip(2) // 앱 화면 load : 1 + textField 터치 : 1 == 2
//        .map { text in
//            // 한글·영문·숫자만, 길이는 2~10자
//            NSPredicate(format: "SELF MATCHES %@", "^[가-힣A-Za-z0-9]{2,10}$")
//                .evaluate(with: text)
//        }
//            .distinctUntilChanged() // 중복값 무시
//        .observe(on: MainScheduler.instance)
//            .subscribe(with: self) { owner, isValid in
//            owner.textField.layer.borderColor = isValid
//                ? UIColor.primary300?.cgColor // 허용 값
//            : UIColor.red0?.cgColor // 불허 값
//
//            owner.cautionLabel.textColor = isValid
//                ? .gray200
//            : .red0?
//        }
//            .disposed(by: disposeBag)
    }
}

