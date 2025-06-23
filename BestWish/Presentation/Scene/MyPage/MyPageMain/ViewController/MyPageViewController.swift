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

final class MyPageViewController: UIViewController {
    private let myPageView = MyPageView()
    private let viewModel: MyPageViewModel
    private let disposeBag = DisposeBag()
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<MyPageSection>(
        configureCell: { dataSource, tableView, indexPath, item in
            switch item {
            case .basic(let type), .seeMore(let type):
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
        self.setNavigationBar(alignment: .left, title: "마이페이지")
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        showTabBar()
        viewModel.action.onNext(.getUserInfo)
    }

    private func bindView() {
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
    }

    private func bindViewModel() {
        viewModel.state.sections
            .bind(to: myPageView.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        viewModel.state.userInfo
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, UserInfoModel in
                owner.setHeaderView(userInfo: UserInfoModel)
            })
            .disposed(by: disposeBag)

        viewModel.state.error
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, error in
                owner.showBasicAlert(title: "네트워크 에러", message: error.localizedDescription)
            }.disposed(by: disposeBag)
    }

    private func setHeaderView(userInfo: UserInfoModel) {
        let frame = CGRect(
            x: 0,
            y: 0,
            width: myPageView.frame.width,
            height: CGFloat(96).fitHeight < 96 ? 96 : CGFloat(96).fitHeight
        )
        let header = MyPageHeaderView(frame: frame)

        header.configure(user: userInfo)
        myPageView.tableView.tableHeaderView = header

        header.seeMoreButton.rx.tap
            .bind(with: self) { owner, _ in
                // Coordinator 적용 전 임시 코드
                owner.hidesTabBar()
                let updateVC = DIContainer.shared.makeProfileUpdateViewController()
                owner.navigationController?.pushViewController(updateVC, animated: true)
            }.disposed(by: disposeBag)
    }
}

//MARK: 문의사항 (메일 띄우기)

extension MyPageViewController: MFMailComposeViewControllerDelegate {
    // 메일 띄우기
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

    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: (any Error)?
    ) {
        controller.dismiss(animated: true)
    }
}
