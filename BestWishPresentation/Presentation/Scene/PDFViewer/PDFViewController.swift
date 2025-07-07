//
//  PDFViewController.swift
//  BestWish
//
//  Created by yimkeul on 6/16/25.
//

import PDFKit
import UIKit

internal import SnapKit
internal import Then

/// pdf 종류
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

/// PDF 컨트롤러
final class PDFViewController: UIViewController {

    private let pdfView = PDFView().then {
        $0.autoScales = true
    }

    init(type: PDFType) {
        super.init(nibName: nil, bundle: nil)
        configure(type: type)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = UIView()
        view.backgroundColor = .gray0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    private func setupLayout() {
        view.addSubview(pdfView)
        pdfView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func configure(type: PDFType) {
        guard let url = type.url else { return }
        pdfView.document = PDFDocument(url: url)
    }
}
