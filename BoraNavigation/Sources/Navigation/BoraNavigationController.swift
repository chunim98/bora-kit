//
//  BoraNavigationController.swift
//  BoraKit
//
//  Created by 신정욱 on 3/6/26.
//

import UIKit

/// 뷰 컨트롤러별 Pop 제스처 활성화 여부를 제어할 수 있는 네비게이션 컨트롤러
/// - Important: `topViewController`가 ``PopGesturePolicy``을 채택한 경우에만 제어가 적용됨
public final class BoraNavigationController: UINavigationController {
    
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
        delegate = self
    }
}

// MARK: UIGestureRecognizerDelegate

extension BoraNavigationController: UIGestureRecognizerDelegate {
    /// 실제로 시작되기 직전에 호출돼서, 시작 여부를 결정
    public func gestureRecognizerShouldBegin(
        _ gestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        // PopGesturePolicy 채택 VC면 해당 설정값으로 시작 여부를 결정
        guard let topVC = topViewController.flatMap({
            $0 as? PopGesturePolicy
        }) else { return true }
        
        return topVC.gestureRecognizerShouldBegin()
    }
}

// MARK: UINavigationControllerDelegate

extension BoraNavigationController: UINavigationControllerDelegate {
    /// 네비게이션 트랜지션 시점에 표시될 화면의 정책을 기준으로 바텀 바 상태 결정
    public func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        (viewController.tabBarController as? TabBarControllerCompatible)?
            .tabBarVisibilityCoordinator.updateVisibility(
                for: viewController,
                animated: animated,
                alongside: navigationController.transitionCoordinator
            )
    }
}
