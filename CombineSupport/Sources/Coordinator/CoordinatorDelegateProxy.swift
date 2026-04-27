//
//  CoordinatorDelegateProxy.swift
//  BoraKit
//
//  Created by 신정욱 on 4/20/26.
//

import UIKit
import Combine

import CombineCocoa

import Navigation

final class CoordinatorDelegateProxy: DelegateProxy {}

// MARK: DelegateProxyType

extension CoordinatorDelegateProxy: DelegateProxyType {
    
    typealias Object = FlowCoordinator
    
    func setDelegate(to object: FlowCoordinator) {
        object.parent = self
    }
}

// MARK: ParentFlowCoordinator

extension CoordinatorDelegateProxy: ParentFlowCoordinator {
    func coordinatorDidFinish(_ child: FlowCoordinator) {
        interceptedSelector(
            #selector(ParentFlowCoordinator.coordinatorDidFinish(_:)),
            arguments: [child]
        )
    }
}
