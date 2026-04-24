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
    
    typealias Object = BaseCoordinator
    
    func setDelegate(to object: BaseCoordinator) {
        object.parent = self
    }
}

// MARK: ParentCoordinator

extension CoordinatorDelegateProxy: ParentCoordinator {
    func coordinatorDidFinish(_ child: BaseCoordinator) {
        interceptedSelector(
            #selector(ParentCoordinator.coordinatorDidFinish(_:)),
            arguments: [child]
        )
    }
}
