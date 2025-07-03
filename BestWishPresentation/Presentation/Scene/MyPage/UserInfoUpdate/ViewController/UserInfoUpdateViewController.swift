//
//  UserInfoUpdateViewController.swift
//  BestWish
//
//  Created by 이수현 on 6/12/25.
//

import UIKit

internal import RxCocoa
internal import RxSwift

/// 유저 정보 업데이트 View Controller
public final class UserInfoUpdateViewController: UIViewController {
    private let viewModel: UserInfoUpdateViewModel
    private let updateView = UserInfoUpdateView()
    private let disposeBag = DisposeBag()

    public init(viewModel: UserInfoUpdateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        view = updateView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar(alignment: .center, title: "회원 정보 수정")
        bindView()
        bindViewModel()

        viewModel.action.onNext(.getUserInfo)
    }

    private func bindView() {
        updateView.birthSelection.dateButton.rx.tap
            .withLatestFrom(viewModel.state.userInfo)
            .map { $0?.birth }
            .bind(with: self) { owner, selectedBirth in
                let sheetVC = DatePickerBottomSheetViewController(baseDate: selectedBirth)
                sheetVC.onDateSelected =  { selectedDate in
                    owner.viewModel.action.onNext(.updateBirth(selectedDate))
                    sheetVC.dismiss(animated: true)
                }
                sheetVC.onCancel = { sheetVC.dismiss(animated: true) }
                sheetVC.presentDatePickerSheet()
                owner.present(sheetVC, animated: true)
            }
            .disposed(by: disposeBag)

        updateView.genderSelection.maleButton.rx.tap
            .asDriver()
            .map { .updateGender(.male) }
            .drive(viewModel.action)
            .disposed(by: disposeBag)

        updateView.genderSelection.femaleButton.rx.tap
            .asDriver()
            .map { .updateGender(.female) }
            .drive(viewModel.action)
            .disposed(by: disposeBag)

        updateView.genderSelection.nothingButton.rx.tap
            .asDriver()
            .map { .updateGender(.nothing) }
            .drive(viewModel.action)
            .disposed(by: disposeBag)

        updateView.saveButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.action.onNext(.saveUserInfo)
            }
            .disposed(by: disposeBag)
    }

    private func bindViewModel() {
        viewModel.state.userInfo
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, userInfo in
                guard let userInfo else { return }
                owner.updateView.configure(userInfo: userInfo)
            }.disposed(by: disposeBag)

        viewModel.state.completedSave
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }.disposed(by: disposeBag)

        viewModel.state.error
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, error in
                owner.showBasicAlert(title: "네트워크 에러", message: error.localizedDescription)
                NSLog("UserInfoUpdateViewController Error: \(error.debugDescription)")
            }.disposed(by: disposeBag)
    }
}
