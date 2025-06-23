//
//  UserInfoUpdateViewController.swift
//  BestWish
//
//  Created by 이수현 on 6/12/25.
//

import UIKit

import RxCocoa
import RxSwift

final class UserInfoUpdateViewController: UIViewController {
    private let updateView = UserInfoUpdateView()
    private let viewModel: UserInfoUpdateViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: UserInfoUpdateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = updateView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar(alignment: .center, title: "회원 정보 수정")
        bindView()
        bindViewModel()

        viewModel.action.onNext(.getUserInfo)
    }

    private func bindView() {
        updateView.birthSelection.dateButton.rx.tap
            .bind(with: self) { owner, _ in
                let sheetVC = DatePickerBottomSheetViewController()
                sheetVC.onDateSelected =  { selectedDate in
                    owner.viewModel.action.onNext(.updateBirth(selectedDate))
                    sheetVC.dismiss(animated: true)
                }
                sheetVC.onCancel = { sheetVC.dismiss(animated: true) }
                sheetVC.presentDatePickerSheet()
                owner.present(sheetVC, animated: true)
            }
            .disposed(by: disposeBag)

        updateView.genderSelection.selectedGender
            .distinctUntilChanged()
            .map { ($0 ?? .nothing).rawValue }
            .bind(with: self) { owner, genderIndex in
                owner.viewModel.action.onNext(.updateGender(genderIndex))
            }
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
            }.disposed(by: disposeBag)
    }
}
