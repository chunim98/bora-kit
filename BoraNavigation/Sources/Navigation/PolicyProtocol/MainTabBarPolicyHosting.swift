//
//  MainTabBarPolicyHosting.swift
//  BoraKit
//
//  Created by 신정욱 on 4/22/26.
//

import UIKit

/// 메인 탭바 정책 프로토콜
public protocol MainTabBarPolicyHosting: NavigationPolicyHosting {
    /// 해당 뷰 컨트롤러가 탭바를 표시해야 하는지 여부
    var hidesMainTabBarWhenPushed: Bool { get }
}
