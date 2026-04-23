//
//  CoordinatorDelegateProxy.swift
//  BoraKit
//
//  Created by 신정욱 on 4/20/26.
//

import UIKit
import Combine

import CombineCocoa

import NavigationSupport

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
    func coordinatorDidFinish(_ child: Coordinator) {
        interceptedSelector(
            #selector(ParentCoordinator.coordinatorDidFinish(_:)),
            arguments: [child]
        )
    }
}
