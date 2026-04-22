//
//  BoraTabBarVisibilityPolicy.swift
//  BoraKit
//
//  Created by 신정욱 on 4/22/26.
//

import UIKit

/// 탭바 표시 여부를 결정하는 정책 프로토콜
/// 화면 전환 시 현재 화면이 탭바를 노출할지 판단할 때 사용
public protocol BoraTabBarVisibilityPolicy: UIViewController {
    /// 해당 뷰 컨트롤러가 탭바를 표시해야 하는지 여부
    var shouldTabBarHide: Bool { get }
}
