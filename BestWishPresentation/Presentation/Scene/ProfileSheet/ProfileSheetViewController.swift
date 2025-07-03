//
//  ProfileSheetViewController.swift
//  BestWish
//
//  Created by 이수현 on 6/10/25.
//

import UIKit

internal import RxCocoa
internal import RxSwift

/// 프로필 시트 View Controller
final class ProfileSheetViewController: UIViewController {
    private let profileSheetView = ProfileSheetView()
    private let disposeBag = DisposeBag()

    private let selectedIndex: BehaviorRelay<Int>
    var onComplete: ((Int) -> Void)? // 프로필 선택 완료 후 이전 VC에 넘겨줌

    init(selectedIndex: Int) {
        self.selectedIndex = BehaviorRelay<Int>(value: selectedIndex)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = profileSheetView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindView()
    }

    private func bindView() {
        // 전체 프로필 이미지 띄우기
        Observable.just(ProfileType.allCases)
            .bind(to: profileSheetView.collectionView.rx.items(
                    cellIdentifier: ProfileSheetCell.identifier,
                    cellType: ProfileSheetCell.self
                )
            ) { [weak self] index, type, cell in
                guard let self else { return }
                // 이미지 선택 표시
                if type.rawValue == selectedIndex.value {
                    let indexPath = IndexPath(row: index, section: 0)

                    profileSheetView.collectionView.selectItem(
                        at: indexPath,
                        animated: false,
                        scrollPosition: [] // 자동 스크롤 제거
                    )
                }
                cell.configure(imageName: type.name)
            }.disposed(by: disposeBag)

        // 프로필 선택
        profileSheetView.collectionView.rx.itemSelected
            .map { $0.item }
            .bind(to: selectedIndex)
            .disposed(by: disposeBag)

        // 완료 버튼
        profileSheetView.completeButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.onComplete?(owner.selectedIndex.value)
                owner.dismiss(animated: true)
            }.disposed(by: disposeBag)
    }

    /// 프로필 시트 설정
    func presentProfileSheet() {
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.custom(resolver: { _ in CGFloat(182).fitHeight })]
            sheet.preferredCornerRadius = 24
        }
    }
}
