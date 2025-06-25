//
//  LinkSaveView.swift
//  BestWish
//
//  Created by 백래훈 on 6/13/25.
//

import UIKit

import RxSwift
import SnapKit
import Then

final class LinkSaveView: UIView {
    private let disposeBag = DisposeBag()
    private let _dismiss = PublishSubject<Void>()
    var dismiss: Observable<Void> { _dismiss.asObservable() }
    
    private let linkView = UIView()
    private let titleLabel = UILabel()
    private let cancelButton = UIButton()
    private let linkInputView = UISearchBar()
    
    private let saveButton: AppButton
    
    var getLinkInputTextField: UITextField { linkInputView.searchTextField }

    init() {
        saveButton = AppButton(type: .save)

        super.init(frame: .zero)

        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    var getSaveButton: AppButton { saveButton }
}

private extension LinkSaveView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setBindings()
    }

    func setAttributes() {
        self.backgroundColor = .black.withAlphaComponent(0.5)

        linkView.do {
            $0.backgroundColor = .gray0
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }

        titleLabel.do {
            $0.text = "링크 저장"
            $0.textColor = .gray900
            $0.font = .font(.pretendardBold, ofSize: 18)
            $0.textAlignment = .center
        }
        
        cancelButton.do {
            var config = UIButton.Configuration.plain()
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)
            
            config.image = UIImage(systemName: "xmark")?.withConfiguration(symbolConfig)
            config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            $0.configuration = config
            $0.tintColor = .gray900
        }

        linkInputView.do {
            $0.backgroundImage = UIImage()
            $0.searchTextField.attributedPlaceholder = NSAttributedString(
                string: "링크를 붙여주세요",
                attributes: [
                    .foregroundColor: UIColor.gray400 ?? .black, // 원하는 placeholder 색상
                    .font: UIFont.font(.pretendardBold, ofSize: 14)
                ]
            )
            $0.searchTextField.font = .font(.pretendardBold, ofSize: 14)
            $0.searchTextField.textColor = .gray900
            let image = UIImage(systemName: "link")?.withRenderingMode(.alwaysTemplate)
            $0.setImage(image, for: .search, state: .normal)
            $0.searchTextField.leftView?.tintColor = .gray200 // 필요 시 색상 설정
        }
    }

    func setHierarchy() {
        self.addSubviews(linkView)
        linkView.addSubviews(titleLabel, cancelButton, linkInputView, saveButton)
    }

    func setConstraints() {
        linkView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        cancelButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().offset(-12)
        }

        linkInputView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(25)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(49)
        }
        
        linkInputView.searchTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalToSuperview()
        }

        saveButton.snp.makeConstraints {
            $0.top.equalTo(linkInputView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(43)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }

    func setBindings() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)

        Observable.merge(
            tapGesture.rx.event.map { _ in },
            cancelButton.rx.tap.map { }
        )
        .subscribe(_dismiss)
        .disposed(by: disposeBag)
    }
}

extension LinkSaveView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchLocation = touch.location(in: self)
        return !linkView.frame.contains(touchLocation)
    }
}
