//
//  TabBarVisibilityCoordinator.swift
//  BoraKit
//
//  Created by 신정욱 on 4/22/26.
//

import UIKit

/// 화면 전환 흐름에 맞춰 커스텀 탭바의 표시 상태를 조율하는 객체
@MainActor
public final class TabBarVisibilityCoordinator {
    
    // MARK: Properties
    
    private weak var tabBar: (any TabBarCompatible)?
    
    /// 전환 취소 시 복구 기준이 되는 마지막 확정 상태
    private var currentVisible: Bool
    
    // MARK: Life Cycle
    
    public init(
        tabBar: any TabBarCompatible,
        initialVisible: Bool = true
    ) {
        self.tabBar = tabBar
        self.currentVisible = initialVisible
    }
    
    // MARK: Public Methods
    
    /// 표시될 화면의 정책을 기준으로 탭바 표시 상태를 갱신
    public func updateVisibility(
        for viewController: UIViewController,
        animated: Bool,
        alongside coordinator: UIViewControllerTransitionCoordinator?
    ) {
        let targetVisible = !(
            (viewController as? TabBarVisibilityPolicy)?.shouldTabBarHide == true
        )
        setVisible(targetVisible, animated: animated, alongside: coordinator)
    }
    
    /// 주어진 표시 상태로 탭바를 갱신하고, 전환 취소 시 이전 확정 상태로 복구
    public func setVisible(
        _ visible: Bool,
        animated: Bool,
        alongside coordinator: UIViewControllerTransitionCoordinator?
    ) {
        guard let tabBar else {
            currentVisible = visible
            return
        }
        
        guard animated, let coordinator else {
            currentVisible = visible
            tabBar.setVisible(visible, animated: animated)
            return
        }
        
        let previousVisible = currentVisible
        tabBar.isUserInteractionEnabled = false
        tabBar.setVisible(visible, alongside: coordinator)
        
        coordinator.animate(alongsideTransition: nil) { [weak self, weak tabBar] context in
            guard let self, let tabBar else { return }
            
            let finalVisible = context.isCancelled ? previousVisible : visible
            self.currentVisible = finalVisible
            tabBar.setVisible(finalVisible, animated: false)
        }
    }
}
