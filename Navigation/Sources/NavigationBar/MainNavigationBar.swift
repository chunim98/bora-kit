//
//  MainNavigationBar.swift
//  BoraKit
//
//  Created by 신정욱 on 4/24/26.
//

import UIKit

/// 컨테이너 역할의 커스텀 네비게이션 바
public protocol MainNavigationBar: UIView {
    /// 네비게이션 바의 고정 높이
    static var height: CGFloat { get }
}
