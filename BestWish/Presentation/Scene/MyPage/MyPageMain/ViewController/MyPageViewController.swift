//
//  MyPageViewController.swift
//  BestWish
//
//  Created by 이수현 on 6/9/25.
//

import MessageUI
import UIKit

import RxCocoa
import RxDataSources
import RxSwift

/// 마이페이지 ViewController
final class MyPageViewController: UIViewController {
    private let viewModel: MyPageViewModel
    private let myPageView = MyPageView()
    private let disposeBag = DisposeBag()
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<MyPageSection>(
        configureCell: { dataSource, tableView, indexPath, item in
            switch item {
            case let .basic(type), let .seeMore(type):
                guard let cell = self.myPageView.tableView.dequeueReusableCell(
                    withIdentifier: MyPageCell.identifier,
                    for: indexPath
                ) as? MyPageCell else {
                    return UITableViewCell()
                }
                cell.configure(type: type)
                return cell
            }
        },
        titleForHeaderInSection: { dataSource, index in
            return dataSource.sectionModels[index].header
        },
        titleForFooterInSection: { dataSource, index in
            return dataSource.sectionModels[index].footer
        }
    )

    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        setNavigationBar(alignment: .left, title: "마이페이지")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = myPageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        bindView()
        viewModel.action.onNext(.getSection)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        showTabBar()
        viewModel.action.onNext(.getUserInfo)
    }

    private func bindView() {
        // 테이블 뷰 아이템 선택 바인딩
        myPageView.tableView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                switch MyPageCellType(indexPath: indexPath) {
                case .userInfo:
                    owner.hidesTabBar()
                    let managementViewController = DIContainer.shared.makeUserInfoManagementViewController()
                    owner.navigationController?.pushViewController(managementViewController, animated: true)
                case .question:
                    owner.sendQuestion()
                case .termsOfUse:
                    let nextVC = PDFViewController(type: .termsOfUse)
                    self.present(nextVC, animated: true)
                case .privacyPolicy:
                    let nextVC = PDFViewController(type: .privacyPolicy)
                    self.present(nextVC, animated: true)
                case .logout:
                    AlertBuilder(baseViewController: self, type: .logout) {
                        owner.viewModel.action.onNext(.logout)
                    }.show()
                default: return
                }
            }.disposed(by: disposeBag)

        // 헤더뷰 셀 선택 바인딩
        let headerTapGesture = UITapGestureRecognizer()
        myPageView.tableHeaderView.addGestureRecognizer(headerTapGesture)
        headerTapGesture.rx.event
            .bind(with: self) { owner, _ in
                owner.hidesTabBar()
                let updateVC = DIContainer.shared.makeProfileUpdateViewController()
                owner.navigationController?.pushViewController(updateVC, animated: true)
            }.disposed(by: disposeBag)
    }

    private func bindViewModel() {
        viewModel.state.sections
            .bind(to: myPageView.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        viewModel.state.userInfo
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, userInfo in
                owner.myPageView.tableHeaderView.configure(user: userInfo)
            })
            .disposed(by: disposeBag)

        viewModel.state.isLogOut
            .observe(on: MainScheduler.instance)
            .bind { _ in
                DummyCoordinator.shared.showLoginView()
            }
            .disposed(by: disposeBag)

        viewModel.state.error
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, error in
                owner.showBasicAlert(title: "네트워크 에러", message: error.localizedDescription)
                NSLog("MyPageViewController Error: \(error.debugDescription)")
            }.disposed(by: disposeBag)
    }
}

// MARK: - 문의사항 (메일 띄우기)
extension MyPageViewController: MFMailComposeViewControllerDelegate {
    /// 메일 띄우기
    private func sendQuestion() {
        // 메일 계정 설정 여부 확인
        guard MFMailComposeViewController.canSendMail() else {
            showBasicAlert(
                title: EmailConstants.mailUnavailableAlertTitle.value,
                message: EmailConstants.mailUnavailableAlertMessage.value
            )
            return
        }

        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self

        // 수신자
        mailComposer.setToRecipients([EmailConstants.recipients.value])

        // 제목
        mailComposer.setSubject(EmailConstants.subject.value)

        // 본문
        let body = EmailConstants.body.value
        mailComposer.setMessageBody(body, isHTML: false)

        // 메일 작성 화면 띄우기
        present(mailComposer, animated: true)
    }

    /// 삭제 버튼 액션 메서드
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: (any Error)?
    ) {
        controller.dismiss(animated: true)
    }
}
