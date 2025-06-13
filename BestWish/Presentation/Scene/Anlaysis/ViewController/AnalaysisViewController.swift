//
//  AnlaysisViewController.swift
//  BestWish
//
//  Created by Quarang on 6/12/25.
//

import UIKit

// MARK: - 이미지 분석 후 검색 뷰 컨트롤러
final class AnalaysisViewController: UIViewController {
    
    private let analysisView = AnalysisView()
    
    override func loadView() {
        view = analysisView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindView()
    }
    
    private func bindView() {
        
    }
}
