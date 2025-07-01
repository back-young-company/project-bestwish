//
//  ProfileSheetView.swift
//  BestWish
//
//  Created by 이수현 on 6/10/25.
//

import UIKit

internal import SnapKit
internal import Then

/// 프로필 시트 뷰
final class ProfileSheetView: UIView {

    // MARK: - Private Property
    private let _titleLabel = UILabel()
    private let _completeButton = AppButton(type: .complete, fontSize: 12)
    private let _layout = UICollectionViewFlowLayout()
    private lazy var _collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: _layout
    )

    // MARK: - Internal Property
    var completeButton: AppButton { _completeButton }
    var collectionView: UICollectionView { _collectionView }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - View 설정
private extension ProfileSheetView {
    func setView() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        self.backgroundColor = .gray0
        _titleLabel.do {
            $0.text = "프로필 이미지"
            $0.textColor = .gray900
            $0.font = .font(.pretendardBold, ofSize: 16)
        }

        _layout.do {
            $0.scrollDirection = .horizontal
            $0.minimumInteritemSpacing = 12
            $0.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
            $0.itemSize = CGSize(
                width: CGFloat(80).fitHeight,
                height: CGFloat(80).fitHeight
            )
        }

        _collectionView.do {
            $0.register(ProfileSheetCell.self, forCellWithReuseIdentifier: ProfileSheetCell.identifier)
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.allowsMultipleSelection = false
            $0.alwaysBounceHorizontal = false
        }
    }

    func setHierarchy() {
        self.addSubviews(_titleLabel, _completeButton, _collectionView)
    }

    func setConstraints() {
        _titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(23.5)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(_completeButton)
        }

        _completeButton.snp.makeConstraints { make in
            make.centerY.equalTo(_titleLabel)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(CGFloat(48).fitWidth)
            make.height.equalTo(CGFloat(26).fitHeight)
        }

        _collectionView.snp.makeConstraints { make in
            make.top.equalTo(_titleLabel.snp.bottom).offset(CGFloat(23.5).fitHeight)
            make.height.equalTo(CGFloat(96.5).fitHeight)
            make.directionalHorizontalEdges.equalToSuperview()
        }
    }
}
