//
//  ImageEditFlowDelegate.swift
//  BestWishPresentation
//
//  Created by 이수현 on 7/2/25.
//

import BestWishDomain
import Foundation

/// 이미지 편집 화면 이동 플로우
public protocol ImageEditFlowDelegate: AnyObject {
    /// 뒤로가기 버튼 터치
    func didTapCancelButton()

    /// 라벨데이터 요청 완료
    func didSetLabelData(labelData: [LabelDataEntity])
}
