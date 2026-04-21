//
//  PopGestureNavigationController.swift
//  BoraKit
//
//  Created by 신정욱 on 3/6/26.
//

import UIKit

/// 뷰 컨트롤러별 Pop 제스처 활성화 여부를 제어할 수 있는 네비게이션 컨트롤러
/// - Important: `topViewController`가 ``PopGestureControllable``을 채택한 경우에만 제어가 적용됨
public final class PopGestureNavigationController: UINavigationController {
    
    // MARK: Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaults()
    }
    
    // MARK: Defaults
    
    private func setupDefaults() {
        if #available(iOS 26.0, *) {
            interactiveContentPopGestureRecognizer?.delegate = self
        }
        interactivePopGestureRecognizer?.delegate = self
    }
}

// MARK: UIGestureRecognizerDelegate

extension PopGestureNavigationController: UIGestureRecognizerDelegate {
    /// 실제로 시작되기 직전에 호출돼서, 시작 여부를 결정
    public func gestureRecognizerShouldBegin(
        _ gestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        // PopGestureControllable 채택 VC면 해당 설정값으로 시작 여부를 결정
        guard let topVC = topViewController.flatMap({
            $0 as? PopGestureControllable
        }) else { return true }
        
        return topVC.gestureRecognizerShouldBegin()
    }
}
