//
//  ParentFlowCoordinator.swift
//  BoraKit
//
//  Created by 신정욱 on 4/20/26.
//

import UIKit

@objc public protocol ParentFlowCoordinator: AnyObject {
    /// 자식 코디네이터 종료 시 호출됨
    /// - 부모에서 이 이벤트를 통해 자식을 정리
    func coordinatorDidFinish(_ child: FlowCoordinator)
}
