//
//  UIViewController+AppTabBarVisibility.swift
//  Navigation
//
//  Created by 신정욱 on 4/22/26.
//

import UIKit

/// 앱 탭바 숨김 정책의 연관 객체 키
fileprivate nonisolated(unsafe) var hidesAppTabBarWhenPushedKey: UInt8 = 0

extension UIViewController {
    /// push 되었을 때 앱 탭바를 숨길지 여부
    public var hidesAppTabBarWhenPushed: Bool {
        get {
            objc_getAssociatedObject(
                self,
                &hidesAppTabBarWhenPushedKey
            ) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(
                self,
                &hidesAppTabBarWhenPushedKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN
            )
        }
    }
}
