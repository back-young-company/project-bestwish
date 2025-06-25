//
//  PDFViewController.swift
//  BestWish
//
//  Created by yimkeul on 6/16/25.
//

import UIKit
import SnapKit
import Then
import PDFKit

enum PDFType {
    case privacyPolicy // 개인정보 처리 방침
    case termsOfUse // 서비스 이용 약관

    var url: URL? {
        switch self {
        case .privacyPolicy:
            return Bundle.main.url(forResource: "privacyPolicy", withExtension: "pdf")
        case .termsOfUse:
            return Bundle.main.url(forResource: "termsOfUse", withExtension: "pdf")
        }
    }
}

final class PDFViewController: UIViewController {

    // MARK: - Properties
    private let pdfView = PDFView().then {
        $0.autoScales = true
    }

    // MARK: - Initializer
    init(type: PDFType) {
        super.init(nibName: nil, bundle: nil)
        configure(type: type)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle
    override func loadView() {
        // 기본 컨테이너 뷰
        view = UIView()
        view.backgroundColor = .gray0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    // MARK: - UI Setup
    private func setupLayout() {
        view.addSubview(pdfView)
        pdfView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    // MARK: - Bind
    private func configure(type: PDFType) {
        guard let url = type.url else { return }
        pdfView.document = PDFDocument(url: url)
    }
}
