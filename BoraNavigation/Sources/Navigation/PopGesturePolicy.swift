//
//  PopGesturePolicy.swift
//  BoraKit
//
//  Created by 신정욱 on 3/9/26.
//

import UIKit

/// 뷰 컨트롤러별로 Pop 제스처 활성화 여부를 제어하기 위한 프로토콜
/// - Important: 해당 뷰 컨트롤러의 `navigationController`가 ``BoraNavigationController``일 때만 적용됨
public protocol PopGesturePolicy: UIViewController {
    /// Pop 제스처의 시작 여부를 결정
    func gestureRecognizerShouldBegin() -> Bool
}
