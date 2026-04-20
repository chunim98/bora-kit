//
//  CoordinatorDelegateProxy.swift
//  BoraKit
//
//  Created by 신정욱 on 4/20/26.
//

import UIKit
import Combine

import CombineCocoa

import BoraNavigation

final class CoordinatorDelegateProxy: DelegateProxy {}

// MARK: DelegateProxyType

extension CoordinatorDelegateProxy: DelegateProxyType {
    
    typealias Object = Coordinator
    
    func setDelegate(to object: Coordinator) {
        object.parent = self
    }
}

// MARK: ParentCoordinator

extension CoordinatorDelegateProxy: ParentCoordinator {
    func didFinish() {
        interceptedSelector(
            #selector(ParentCoordinator.didFinish),
            arguments: []
        )
    }
}
