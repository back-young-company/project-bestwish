//
//  ViewModel.swift
//  BestWish
//
//  Created by 이수현 on 6/4/25.
//

import RxSwift

/// 앱 내 ViewModel의 프로토콜
protocol ViewModel {
    associatedtype Action
    associatedtype State

    var action: AnyObserver<Action> { get }
    var state: State { get }
}
