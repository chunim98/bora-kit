//
//  AppNavigationController.swift
//  BoraKit
//
//  Created by 신정욱 on 3/6/26.
//

import UIKit

open class AppNavigationController: UINavigationController {
    
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

extension AppNavigationController: UIGestureRecognizerDelegate {
    /// 실제로 시작되기 직전에 호출돼서, 시작 여부를 결정
    open func gestureRecognizerShouldBegin(
        _ gestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        // PopGesturePolicyHosting 채택 VC면 해당 설정값으로 시작 여부를 결정
        guard let topVC = topViewController.flatMap({
            $0 as? PopGesturePolicyHosting
        }) else { return true }
        
        return topVC.gestureRecognizerShouldBegin()
    }
}

// MARK: UINavigationControllerDelegate

extension AppNavigationController: UINavigationControllerDelegate {
    /// 네비게이션 트랜지션 시점에 표시될 화면의 정책을 기준으로 바텀 바 상태 결정
    open func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated _: Bool
    ) {
        let tabBarVC = viewController.tabBarController as? (any MainTabBarContaining)
        
        // 스택 안에 탭바 숨김 화면이 하나라도 남아있으면, 탭바를 노출하지 않음
        let shouldHide = navigationController.viewControllers.contains {
            $0.hidesMainTabBarWhenPushed
        }
        
        tabBarVC?.mainTabBar.setHidden(
            shouldHide,
            transitionCoordinator: navigationController.transitionCoordinator
        )
    }
}
