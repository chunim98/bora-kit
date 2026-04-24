//
//  BaseCoordinator+Combine.swift
//  BoraKit
//
//  Created by 신정욱 on 4/20/26.
//

import Combine

import Navigation

extension BaseCoordinator {
    /// 델리게이트 프록시
    var delegateProxy: CoordinatorDelegateProxy {
        CoordinatorDelegateProxy.createDelegateProxy(for: self)
    }
    
    /// 코디네이터 종료 이벤트 스트림
    /// - 부모에서 이 이벤트를 구독해서 자식을 정리
    public var didFinishPublisher: AnyPublisher<Void, Never> {
        delegateProxy.interceptSelectorPublisher(
            #selector(ParentCoordinator.coordinatorDidFinish(_:))
        )
        .map { _ in }
        .eraseToAnyPublisher()
    }
}
