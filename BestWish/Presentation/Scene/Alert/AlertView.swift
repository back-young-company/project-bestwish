//
//  AlertView.swift
//  BestWish
//
//  Created by 이수현 on 6/12/25.
//

import UIKit
import RxSwift

final class AlertView: UIView {
    private let disposeBag = DisposeBag()
    private let _dismiss = PublishSubject<Void>()
    var dismiss: Observable<Void> { _dismiss.asObservable() }

    private let type: AlertType

    private let alertView = UIView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    let cancelButton: AppButton
    let confirmButton: AppButton

    init(type: AlertType) {
        self.type = type
        cancelButton = AppButton(type: type.cancelButtonType)
        confirmButton = AppButton(type: type.confirmButtonType)

        super.init(frame: .zero)

        setView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}

private extension AlertView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setBindings()
    }

    func setAttributes() {
        self.backgroundColor = .black.withAlphaComponent(0.5)

        alertView.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }

        titleLabel.do {
            $0.text = type.title
            $0.textColor = .gray800
            $0.font = .font(.pretendardBold, ofSize: 16)
            $0.textAlignment = .center
        }

        subTitleLabel.do {
            $0.text = type.subTitle
            $0.textColor = .gray600
            $0.font = .font(.pretendardMedium, ofSize: 12)
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
    }

    func setHierarchy() {
        self.addSubviews(alertView)
        alertView.addSubviews(titleLabel, subTitleLabel, cancelButton, confirmButton)
    }

    func setConstraints() {
        alertView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.directionalHorizontalEdges.equalToSuperview().inset(20)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.directionalHorizontalEdges.equalToSuperview()
            make.height.equalTo(35)
        }

        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.directionalHorizontalEdges.equalToSuperview()
        }

        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(24)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(CGFloat(43).fitHeight)
        }

        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(cancelButton.snp.bottom).offset(6)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(CGFloat(43).fitHeight)
            make.bottom.equalToSuperview().inset(20)
        }
    }

    func setBindings() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .map { _ in }
            .subscribe(_dismiss)
            .disposed(by: disposeBag)
    }
}

extension AlertView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchLocation = touch.location(in: self)
        return !alertView.frame.contains(touchLocation)
    }
}
