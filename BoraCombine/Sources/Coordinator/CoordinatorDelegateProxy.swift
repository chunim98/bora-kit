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
    
    typealias Object = BoraCoordinator
    
    func setDelegate(to object: BoraCoordinator) {
        object.parent = self
    }
}

// MARK: ParentCoordinator

extension CoordinatorDelegateProxy: BoraParentCoordinator {
    func didFinish() {
        interceptedSelector(
            #selector(BoraParentCoordinator.didFinish),
            arguments: []
        )
    }
}
