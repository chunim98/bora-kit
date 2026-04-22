//
//  TabBarControllerCompatible.swift
//  BoraKit
//
//  Created by 신정욱 on 4/22/26.
//

import UIKit

/// 커스텀 탭바를 구현한 탭바 컨트롤러 타입 프로토콜
public protocol TabBarControllerCompatible: UIViewController {
    /// 시스템 TabBar의 제약을 피하고 자유로운 애니메이션 구현을 위해 커스텀 객체 사용
    var mainTabBar: TabBarCompatible { get }
}
