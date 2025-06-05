//
//  DummyView.swift
//  BestWish
//
//  Created by 이수현 on 6/3/25.
//

import UIKit
import Then
import SnapKit

final class DummyView: UIView {
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(with data: DummyDisplay) {
        titleLabel.text = data.title
        priceLabel.text = data.price
    }
}

private extension DummyView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setDelegate()
        setDataSource()
        setBindings()
    }

    // View에 대한 속성 설정 메서드
    func setAttributes() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        self.clipsToBounds = true

        titleLabel.do { label in
            label.textColor = .black
            label.font = .font(.pretendardBold, ofSize: 14)
        }

        priceLabel.do { label in
            label.textColor = .black
            label.font = .font(.pretendardLight, ofSize: 14)
        }
    }

    // subView 추가 메서드
    func setHierarchy() {
        self.addSubviews(titleLabel, priceLabel)
    }

    // 오토레이이아웃 설정 메서드
    func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
    }

    // 딜리게이트 설정
    func setDelegate() {
        // tableView.delegate = self
    }

    // 데이터 소스 설정
    func setDataSource() {
        // tableView.delegate = self
    }

    func setBindings() {
        // button.rx.tap.bind {}
    }
}
