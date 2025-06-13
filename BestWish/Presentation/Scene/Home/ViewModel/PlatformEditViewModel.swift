//
//  PlatformEditViewModel.swift
//  BestWish
//
//  Created by 백래훈 on 6/12/25.
//

import Foundation

import RxSwift

final class PlatformEditViewModel: ViewModel {
    
    enum Action {
        
    }
    
    struct State {
        let sections = Observable<[PlatformEditSectionModel]>.just([
            PlatformEditSectionModel(header: "헤더", items: [
                PlatformEdit(platformName: "무신사", platformImage: PlatformImage.musinsa, platformCount: 11),
                PlatformEdit(platformName: "지그재그", platformImage: PlatformImage.zigzag, platformCount: 10),
                PlatformEdit(platformName: "에이블리", platformImage: PlatformImage.ably, platformCount: 9),
                PlatformEdit(platformName: "KREAM", platformImage: PlatformImage.kream, platformCount: 8),
                PlatformEdit(platformName: "브랜디", platformImage: PlatformImage.brandy, platformCount: 7),
                PlatformEdit(platformName: "29CM", platformImage: PlatformImage.tncm, platformCount: 6),
                PlatformEdit(platformName: "OCO", platformImage: PlatformImage.oco, platformCount: 5),
                PlatformEdit(platformName: "4910", platformImage: PlatformImage.fnoz, platformCount: 4),
                PlatformEdit(platformName: "웍스아웃", platformImage: PlatformImage.worksout, platformCount: 3),
                PlatformEdit(platformName: "EQL", platformImage: PlatformImage.eql, platformCount: 2),
                PlatformEdit(platformName: "하이버", platformImage: PlatformImage.hiver, platformCount: 1)
            ])
        ])
    }
    
    private let _action = PublishSubject<Action>()
    var action: AnyObserver<Action> { _action.asObserver() }
    
    let state: State
    
    private let disposeBag = DisposeBag()
    
    init() {
        state = State()
    }
}
