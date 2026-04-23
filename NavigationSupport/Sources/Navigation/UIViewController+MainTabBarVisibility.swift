//
//  UIViewController+MainTabBarVisibility.swift
//  BoraKit
//
//  Created by 신정욱 on 4/22/26.
//

import UIKit

/// 메인 탭바 숨김 정책의 연관 객체 키
fileprivate nonisolated(unsafe) var hidesMainTabBarWhenPushedKey: UInt8 = 0

extension UIViewController {
    /// push 되었을 때 메인 탭바를 숨길지 여부
    public var hidesMainTabBarWhenPushed: Bool {
        get {
            objc_getAssociatedObject(
                self,
                &hidesMainTabBarWhenPushedKey
            ) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(
                self,
                &hidesMainTabBarWhenPushedKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN
            )
        }
    }
}
